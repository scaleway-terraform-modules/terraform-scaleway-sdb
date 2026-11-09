provider "scaleway" {}

module "sdb" {
  source = "../.."

  name = "example-serverless-container"

  access_levels = {
    rw = {}
  }
}

# Latest version of the secret holding the secret key of the `rw` access level.
# The access key is unknown while the API key is being replaced (e.g. rotated),
# so the condition defers the read to the apply, once the new secret key is
# written: the container then gets it.
data "scaleway_secret_version" "rw" {
  secret_id = module.sdb.access["rw"].access_key != null ? module.sdb.access["rw"].secret_id : null
  revision  = "latest"
}

resource "scaleway_container_namespace" "app" {
  name = "example-serverless-container"
}

resource "scaleway_container" "app" {
  name         = "app"
  namespace_id = scaleway_container_namespace.app.id
  image        = var.image

  secret_environment_variables = {
    DATABASE_URL = format("postgres://%s:%s@%s",
      module.sdb.access["rw"].application_id,
      base64decode(data.scaleway_secret_version.rw.data),
      trimprefix(module.sdb.database_endpoint, "postgres://"),
    )
  }
}
