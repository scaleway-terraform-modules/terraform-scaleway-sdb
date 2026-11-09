provider "scaleway" {}

module "sdb" {
  source = "../.."

  name = "example-simple"
}
