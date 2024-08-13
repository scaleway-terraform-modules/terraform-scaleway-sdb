resource "scaleway_sdb_sql_database" "main" {
  name = var.name

  min_cpu = var.min_cpu
  max_cpu = var.max_cpu

  region = var.region
}
