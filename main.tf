resource "scaleway_sdb_sql_database" "main" {
  name = var.name

  min_cpu = var.min_cpu
  max_cpu = var.max_cpu

  project_id = var.project_id
  region     = var.region
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
