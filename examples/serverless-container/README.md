# Serverless Container

This example runs an application in a Serverless Container, with read and write access to the data of the database: the `rw` access level only.

The container gets the connection string in its `DATABASE_URL` secret environment variable, built from the IAM application ID (user name), the latest version of the `rw` secret (password) and the database endpoint.

Reading the secret version puts the secret key in the Terraform state of this configuration, as the container's environment does: only the module itself keeps it out of the state.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply -var image=rg.fr-par.scw.cloud/my-namespace/my-app:1.0.0
```
