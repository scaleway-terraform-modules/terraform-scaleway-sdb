resource "scaleway_sdb_sql_database" "main" {
  name = var.name

  min_cpu = var.min_cpu
  max_cpu = var.max_cpu

  project_id = var.project_id
  region     = var.region
  version    = var.postgresql_version
}

# A warning only: the API rejects the creation of a database with an unavailable
# version, and an existing database must keep its plans working once its version
# is no longer offered.
check "postgresql_version_available" {
  data "scaleway_sdb_sql_versions" "available" {
    region = var.region
  }

  assert {
    condition     = var.postgresql_version == null || contains(data.scaleway_sdb_sql_versions.available.versions[*].name, var.postgresql_version)
    error_message = format("PostgreSQL %s isn't offered by Scaleway Serverless SQL Databases in region %s: a new database can't be created with it. Versions offered: %s.", coalesce(var.postgresql_version, "null"), coalesce(data.scaleway_sdb_sql_versions.available.region, "unknown"), join(", ", data.scaleway_sdb_sql_versions.available.versions[*].name))
  }
}

# The keys are rotated `keys_rotation_window` days before they expire, so that
# an apply run during that window replaces them while they are still valid.
resource "time_rotating" "keys_ttl" {
  count         = var.keys_ttl > 0 ? 1 : 0
  rotation_days = var.keys_ttl - var.keys_rotation_window
}

locals {
  # Expiry of the API keys: `keys_ttl` days after their creation (the base timestamp of `time_rotating`).
  keys_expires_at = var.keys_ttl > 0 ? timeadd(time_rotating.keys_ttl[0].rfc3339, "${var.keys_ttl * 24}h") : null
}
