provider "scaleway" {}

# A secret managed outside this configuration, e.g. one the application
# already reads. It must exist before the first apply: the module needs its ID
# when Terraform plans.
data "scaleway_secret" "app" {
  name = "billing-database-password"
  path = "/billing"
}

module "sdb" {
  source = "../.."

  name     = "example-existing-secret"
  keys_ttl = 90

  access_levels = {
    admin = {}
    rw    = { secret_id = data.scaleway_secret.app.id }
  }
}
