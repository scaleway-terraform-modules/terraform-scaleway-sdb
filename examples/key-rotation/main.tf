provider "scaleway" {}

# The API keys expire 30 days after their creation. Terraform replaces them
# from 7 days before they expire, when it runs: apply this configuration at
# least once a week, e.g. with a scheduled pipeline.
module "sdb" {
  source = "../.."

  name = "example-key-rotation"

  keys_ttl             = 30
  keys_rotation_window = 7
}
