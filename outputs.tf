output "endpoint" {
  description = "Endpoint of the database."
  value       = scaleway_sdb_sql_database.main.endpoint
}
