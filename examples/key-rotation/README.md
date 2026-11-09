# Key rotation

This example creates a database whose API keys expire 30 days after their creation (`keys_ttl`).

Terraform replaces the keys `keys_rotation_window` days (7 here) before they expire, but only when it runs: apply this configuration at least once during that window, e.g. with a weekly scheduled pipeline, or the keys expire and connections are refused.

Each new key writes its secret key as a new version of the access level's secret. The old version is deleted when its key expires. Consumers must read the latest version of the secret before connecting again.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```

Run `terraform apply` again during the rotation window to rotate the keys.
