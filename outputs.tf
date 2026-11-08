output "endpoint" {
  description = "Endpoint of the database."
  value       = scaleway_sdb_sql_database.main.endpoint
}

output "admin_connection_string" {
  description = "Connection string with read and write access to data and schema."
  value = format("postgres://%s:%s@%s",
    scaleway_iam_application.admin.id,
    scaleway_iam_api_key.admin.secret_key,
    trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
  )
  sensitive = true
}

output "ro_connection_string" {
  description = "Connection string with read access to data."
  value = format("postgres://%s:%s@%s",
    scaleway_iam_application.ro.id,
    scaleway_iam_api_key.ro.secret_key,
    trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
  )
  sensitive = true
}

output "rw_connection_string" {
  description = "Connection string with read and write access to data, without schema changes."
  value = format("postgres://%s:%s@%s",
    scaleway_iam_application.rw.id,
    scaleway_iam_api_key.rw.secret_key,
    trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
  )
  sensitive = true
}
