# Existing secret

This example stores the secret key of the `rw` access level in an existing Secret Manager secret, e.g. one the application already reads. The module creates a secret for the `admin` access level, under `/sdb/example-existing-secret`.

The secret must exist before the first apply, as the module needs its ID when Terraform plans: here, an opaque secret named `billing-database-password`, under `/billing`, in the provider's project and region.

The module only adds versions to the secrets it doesn't create. Each key rotation adds a version, and a secret holds 20 versions at most: give the secret an ephemeral policy deleting each version after `keys_ttl` days (90 here), when its API key expires.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, create the secret, then:

```sh
terraform init
terraform apply
```
