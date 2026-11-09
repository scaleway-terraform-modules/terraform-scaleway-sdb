provider "scaleway" {}

# Only the `ro` access level: no credentials able to write data or change the
# schema are created.
module "sdb" {
  source = "../.."

  name = "example-read-only-access"

  access_levels = {
    ro = {}
  }
}
