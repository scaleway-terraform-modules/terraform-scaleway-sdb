resource "scaleway_sdb_sql_database" "main" {
  name = var.name

  min_cpu = var.min_cpu
  max_cpu = var.max_cpu

  region = var.region
}

resource "time_rotating" "keys_ttl" {
  count         = var.keys_ttl > 0 ? 1 : 0
  rotation_days = var.keys_ttl
}
