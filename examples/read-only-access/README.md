# Read-only access

This example creates a database with only the `ro` access level, e.g. for a reporting tool: it can read data (`SELECT`), but neither write data nor change the schema.

No credentials are created for the `admin` and `rw` access levels.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```

The tool connects to `database_endpoint` with `ro_application_id` as user name, and the latest version of the secret given by `ro_secret_id` as password.
