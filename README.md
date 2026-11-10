# Terraform / Scaleway

## Purpose

This repository is used to manage Serverless SQL Databases on Scaleway using Terraform, with IAM credentials to connect to them.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

```hcl
module "sdb" {
  source  = "scaleway-terraform-modules/sdb/scaleway"
  version = "~> 1.0"

  name = "my-database"
}
```

Consumers connect to `module.sdb.database_endpoint`, with `module.sdb.access["rw"].application_id` as user name, and the latest version of the secret given by `module.sdb.access["rw"].secret_id` as password (see [Access levels](#access-levels) and [Secret keys](#secret-keys)).

See the [examples](examples) folder for runnable configurations covering the most common use-cases (read-only access, key rotation, existing secret, Serverless Container).

### Access levels

The module creates one IAM application, policy and API key per access level in `access_levels` (all three by default), and returns its credentials in the `access` output, keyed by level:

| Access level | Permission set | PostgreSQL role | Allowed |
|---|---|---|---|
| `admin` | `ServerlessSQLDatabaseReadWrite` | `role_admin` | Read and write data, change the schema (`CREATE`, `ALTER`, `DROP`) |
| `rw` | `ServerlessSQLDatabaseDataReadWrite` | `role_readwrite` | Read and write data (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`) |
| `ro` | `ServerlessSQLDatabaseReadOnly` | `role_readonly` | Read data (`SELECT`) |

> [!IMPORTANT]
> Scaleway IAM policies can't target a single Serverless SQL Database: each access level applies to **every Serverless SQL Database of the project**. Use a dedicated project (`project_id`) for a database that must be isolated.

### Secret keys

The secret key of each API key is written as a new version of a Secret Manager secret, and isn't stored in the Terraform state. For each access level, the secret is the one given by its `secret_id`, or else an opaque secret created by the module, named after the level (`admin`, `rw`, `ro`), under `key_secrets_path` (`/sdb/<name>` by default), in the database's region and project:

```hcl
access_levels = {
  admin = {}                                                           # secret created by the module
  rw    = { secret_id = "fr-par/11111111-2222-4333-8444-555555555555" } # existing secret
}
```

The module only adds versions to the secrets it doesn't create. Two instances of the module with the same `name` in the same project and region need different `key_secrets_path`.

To connect, consumers read the secret key from the secret given by `access[level].secret_id`, and use `access[level].application_id` as user name, on `database_endpoint`.

Each key rotation adds a version to the secret, and a secret holds 20 versions at most. With `keys_ttl` greater than 0, the secrets created by the module delete each version `keys_ttl` days after its creation, when its API key expires; `keys_ttl` must then be at most 365. The module doesn't manage the secrets given by `secret_id`: give them an ephemeral policy deleting versions after `keys_ttl` days, or delete old versions yourself.

> [!NOTE]
> `secret_id` must be known when Terraform plans: an ID written in the configuration, or read from an existing secret with the `scaleway_secret` data source. If the secret is created in the same configuration, the plan fails with "Invalid for_each argument": create the secret first (`terraform apply -target=<secret resource>`), then apply the whole configuration.

### Key rotation

With `keys_ttl` greater than 0, the IAM API keys expire `keys_ttl` days after their creation. Terraform replaces them `keys_rotation_window` days (7 by default) before they expire, but only when it runs:

- Apply the module at least once during the rotation window (e.g. with a scheduled pipeline), or the keys expire and connections are refused.
- The new keys are created before the old ones are deleted, but both happen in the same apply: the new secret key is written as a new version of the secret, and consumers must read it before connecting again.

### CPU autoscaling

The database scales its compute between `min_cpu` and `max_cpu` vCPUs (0 to 15), with 4 GB of RAM per vCPU. With `min_cpu = 0` (the default), it scales to zero when idle: no compute is billed then, but the first connection after an idle period waits for the database to start. A higher `min_cpu` avoids that delay, at the cost of always billing that compute.

### Changes that recreate the database

> [!WARNING]
> Changing `name`, `postgresql_version`, `project_id` or `region` creates a new, empty database and deletes the old one, **with its data**: the Scaleway API can't change them in place. `terraform plan` shows the database as `must be replaced`: check the plan before applying.

To change one of them, e.g. to upgrade PostgreSQL, create a second instance of the module with the new value, copy the data (e.g. with `pg_dump` and `pg_restore`), switch the consumers to its credentials, then remove the old instance.

The module warns during `plan` when `postgresql_version` isn't offered in the database's region.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.11 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement_scaleway) | >= 2.88.0 |
| <a name="requirement_time"></a> [time](#requirement_time) | >= 0.7.1 |

## Resources

| Name | Type |
|------|------|
| [scaleway_iam_api_key.admin](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/iam_api_key) | resource |
| [scaleway_iam_api_key.ro](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/iam_api_key) | resource |
| [scaleway_iam_api_key.rw](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/iam_api_key) | resource |
| [scaleway_iam_application.admin](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/iam_application) | resource |
| [scaleway_iam_application.ro](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/iam_application) | resource |
| [scaleway_iam_application.rw](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/iam_application) | resource |
| [scaleway_iam_policy.admin](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/iam_policy) | resource |
| [scaleway_iam_policy.ro](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/iam_policy) | resource |
| [scaleway_iam_policy.rw](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/iam_policy) | resource |
| [scaleway_sdb_sql_database.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/sdb_sql_database) | resource |
| [scaleway_secret.keys](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/secret) | resource |
| [time_rotating.keys_ttl](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | Name of the database. Changing it recreates the database, and its data is lost. | `string` | n/a | yes |
| <a name="input_access_levels"></a> [access_levels](#input_access_levels) | Access levels to create an IAM application, policy and API key for, among `admin`, `rw` and `ro`. The secret key of each API key is stored in the Secret Manager secret given by `secret_id` (UUID or `{region}/{id}`; the module only adds versions to it), or in a secret created by the module when `secret_id` is null. `secret_id` must be known at plan time: it can't come from a resource created in the same apply. Each key rotation adds a version to the secret, and a secret holds 20 versions at most: the module deletes old versions of the secrets it creates, but not of the ones given by `secret_id`. Removing a level deletes its API key, and the secret created for it. Changing `secret_id` recreates the API key. | ```map(object({ secret_id = optional(string) }))``` | ```{ "admin": {}, "ro": {}, "rw": {} }``` | no |
| <a name="input_key_secrets_path"></a> [key_secrets_path](#input_key_secrets_path) | Path of the Secret Manager secrets created for the secret keys. Defaults to `/sdb/<name>` when null. | `string` | `null` | no |
| <a name="input_keys_rotation_window"></a> [keys_rotation_window](#input_keys_rotation_window) | Number of days before the expiry of the IAM keys during which Terraform replaces them. Rotation only happens when Terraform runs: apply the module at least once during this window, or the keys expire. Ignored when `keys_ttl` is 0. | `number` | `7` | no |
| <a name="input_keys_ttl"></a> [keys_ttl](#input_keys_ttl) | TTL of IAM keys in days. | `number` | `0` | no |
| <a name="input_max_cpu"></a> [max_cpu](#input_max_cpu) | Maximum number of CPU units for your database. | `number` | `15` | no |
| <a name="input_min_cpu"></a> [min_cpu](#input_min_cpu) | Minimum number of CPU units for your database. | `number` | `0` | no |
| <a name="input_postgresql_version"></a> [postgresql_version](#input_postgresql_version) | PostgreSQL major version of the database, e.g. `16`. The API's default version is used when null. Changing it recreates the database, and its data is lost: see the README to upgrade. | `string` | `null` | no |
| <a name="input_project_id"></a> [project_id](#input_project_id) | ID of the project the database is associated with. Resource will be created in the project set at the provider level if null. Changing it recreates the database, and its data is lost. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input_region) | Region in which the database should be created, e.g. `fr-par`. Resource will be created in the region set at the provider level if null. Changing it recreates the database, and its data is lost. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access"></a> [access](#output_access) | Credentials of each access level listed in `access_levels`: IAM application ID (the user name to connect to the database), API access key, and ID of the Secret Manager secret holding the API secret key (the password to connect to the database). |
| <a name="output_database_endpoint"></a> [database_endpoint](#output_database_endpoint) | Endpoint of the database. |
| <a name="output_database_id"></a> [database_id](#output_database_id) | ID of the database, in the `{region}/{id}` format. |
| <a name="output_database_name"></a> [database_name](#output_database_name) | Name of the database. |
| <a name="output_database_project_id"></a> [database_project_id](#output_database_project_id) | ID of the project the database is associated with. |
| <a name="output_database_region"></a> [database_region](#output_database_region) | Region of the database. |
| <a name="output_database_srn"></a> [database_srn](#output_database_srn) | Scaleway Resource Name (SRN) of the database. |
| <a name="output_database_version"></a> [database_version](#output_database_version) | PostgreSQL major version of the database. |
| <a name="output_database_version_end_of_life_at"></a> [database_version_end_of_life_at](#output_database_version_end_of_life_at) | End of life date of the PostgreSQL version of the database (RFC 3339 format). |
<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-sdb/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-sdb/tree/main/LICENSE) for full details.
