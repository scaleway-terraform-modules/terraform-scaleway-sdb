# Terraform / Scaleway

## Purpose

This repository is used to manage Serverless Databases on scaleway using terraform.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

```hcl
module "sdb" {
  source  = "scaleway-terraform-modules/sdb/scaleway"
  version = "~> 0.0"

  # insert required variables here
}
```

### Access levels

The module creates one IAM application, policy and API key per access level listed in `access_levels` (all three by default), and returns its credentials in the `access` and `connection_strings` outputs, keyed by level:

| Access level | Permission set | PostgreSQL role | Allowed |
|---|---|---|---|
| `admin` | `ServerlessSQLDatabaseReadWrite` | `role_admin` | Read and write data, change the schema (`CREATE`, `ALTER`, `DROP`) |
| `rw` | `ServerlessSQLDatabaseDataReadWrite` | `role_readwrite` | Read and write data (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`) |
| `ro` | `ServerlessSQLDatabaseReadOnly` | `role_readonly` | Read data (`SELECT`) |

> [!IMPORTANT]
> Scaleway IAM policies can't target a single Serverless SQL Database: each access level applies to **every Serverless SQL Database of the project**. Use a dedicated project (`project_id`) for a database that must be isolated.

### Key rotation

With `keys_ttl` greater than 0, the IAM API keys expire `keys_ttl` days after their creation. Terraform replaces them `keys_rotation_window` days (7 by default) before they expire, but only when it runs:

- Apply the module at least once during the rotation window (e.g. with a scheduled pipeline), or the keys expire and the connection strings stop working.
- The new keys are created before the old ones are deleted, but both happen in the same apply: update the consumers of the connection strings in that apply too.

### Upgrading PostgreSQL

Serverless SQL Databases can't be upgraded in place to another PostgreSQL major version: changing `postgresql_version` creates a new, empty database and deletes the old one, **with its data**. The same happens when changing `project_id` or `region`.

The module warns during `plan` when `postgresql_version` isn't offered in the database's region.

To upgrade, create a second instance of the module with the new version, copy the data (e.g. with `pg_dump` and `pg_restore`), switch the consumers to its connection strings, then remove the old instance.

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
| [scaleway_sdb_sql_database.main](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/sdb_sql_database) | resource |
| [time_rotating.keys_ttl](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | Name of the database. | `string` | n/a | yes |
| <a name="input_access_levels"></a> [access_levels](#input_access_levels) | Access levels to create an IAM application, policy, API key and connection string for, among `admin`, `rw` and `ro`. Removing a level deletes its API key. | `set(string)` | ```[ "admin", "rw", "ro" ]``` | no |
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
| <a name="output_access"></a> [access](#output_access) | Credentials of each access level listed in `access_levels`: IAM application ID (the user name in the connection strings), API access key, and API secret key (the password in the connection strings). |
| <a name="output_connection_strings"></a> [connection_strings](#output_connection_strings) | Connection string of each access level listed in `access_levels`. |
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

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-sdb/tree/master/LICENSE) for full details.
