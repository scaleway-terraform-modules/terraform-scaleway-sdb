# Terraform / Scaleway

## Purpose

This repository is used to manage Serverless Databases on scaleway using terraform.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

```hcl
module "sdb" {
  source  = "scaleway-terraform-modules/sdb/scaleway"

  # insert required variables here
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement_scaleway) | >= 2.43.0 |
| <a name="requirement_time"></a> [time](#requirement_time) | 0.12.0 |

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
| [time_rotating.keys_ttl](https://registry.terraform.io/providers/hashicorp/time/0.12.0/docs/resources/rotating) | resource |
| [scaleway_account_project.current](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/account_project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | Name of the database. | `string` | n/a | yes |
| <a name="input_keys_ttl"></a> [keys_ttl](#input_keys_ttl) | TTL of IAM keys in days. | `number` | `0` | no |
| <a name="input_max_cpu"></a> [max_cpu](#input_max_cpu) | Maximum number of CPU units for your database. | `number` | `15` | no |
| <a name="input_min_cpu"></a> [min_cpu](#input_min_cpu) | Minimum number of CPU units for your database. | `number` | `0` | no |
| <a name="input_region"></a> [region](#input_region) | Region in which the resource exists. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_connection_string"></a> [admin_connection_string](#output_admin_connection_string) | Connection string to connect with admin permissions. |
| <a name="output_endpoint"></a> [endpoint](#output_endpoint) | Endpoint of the database. |
| <a name="output_ro_connection_string"></a> [ro_connection_string](#output_ro_connection_string) | Connection string to connect with read only permissions. |
| <a name="output_rw_connection_string"></a> [rw_connection_string](#output_rw_connection_string) | Connection string to connect with read/write permissions. |
<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-domain/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-domain/tree/master/LICENSE) for full details.
