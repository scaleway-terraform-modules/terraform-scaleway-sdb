output "endpoint" {
  description = "Endpoint of the database."
  value       = scaleway_sdb_sql_database.main.endpoint
}

output "admin_connection_string" {
  description = "Connection string to connect with admin permissions."
  value = format("postgres://%s:%s@%s",
    scaleway_iam_application.admin.id,
    scaleway_iam_api_key.admin.secret_key,
    trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
  )
  sensitive = true
}

output "ro_connection_string" {
  description = "Connection string to connect with read only permissions."
  value = format("postgres://%s:%s@%s",
    scaleway_iam_application.ro.id,
    scaleway_iam_api_key.ro.secret_key,
    trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
  )
  sensitive = true
}

output "rw_connection_string" {
  description = "Connection string to connect with read/write permissions."
  value = format("postgres://%s:%s@%s",
    scaleway_iam_application.rw.id,
    scaleway_iam_api_key.rw.secret_key,
    trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
  )
  sensitive = true
}
