# Simple database

This example shows the minimal setup: a Serverless SQL Database with the module's default settings.

It creates the three access levels (`admin`, `rw` and `ro`), each with an IAM application, a policy and an API key whose secret key is stored in a Secret Manager secret, under `/sdb/example-simple`. The keys never expire.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```

To connect with an access level, e.g. `rw`, use `access["rw"].application_id` as user name, and the latest version of the secret given by `access["rw"].secret_id` as password, on `database_endpoint`:

```sh
terraform output -json access
terraform output database_endpoint
```
