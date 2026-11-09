locals {
  # Secret holding the secret key of each access level: the one given in
  # `access_levels`, or the one created by the module.
  key_secret_ids = merge(
    { for level, secret in scaleway_secret.keys : level => secret.id },
    { for level, config in var.access_levels : level => config.secret_id if config.secret_id != null },
  )
}

# One Secret Manager secret per access level without a `secret_id`, holding
# the secret key of its API key: the secret keys aren't stored in the
# Terraform state.
resource "scaleway_secret" "keys" {
  for_each = { for level, config in var.access_levels : level => config if config.secret_id == null }

  name        = each.key
  path        = coalesce(var.key_secrets_path, "/sdb/${var.name}")
  description = format("Secret key of the %s access level of Serverless SQL Database %s", each.key, var.name)
  type        = "opaque"
  region      = scaleway_sdb_sql_database.main.region
  project_id  = scaleway_sdb_sql_database.main.project_id

  # Delete each version when the API key whose secret key it holds expires, so
  # that rotations don't pile up versions (a secret holds 20 at most).
  dynamic "ephemeral_policy" {
    for_each = var.keys_ttl > 0 ? [1] : []
    content {
      action = "delete"
      ttl    = "${var.keys_ttl * 24}h"
    }
  }

  lifecycle {
    precondition {
      condition     = var.keys_ttl <= 365
      error_message = "'keys_ttl' must be at most 365 when the module creates secrets: their versions are deleted after 'keys_ttl' days, and Secret Manager accepts 1 year at most."
    }
  }
}
