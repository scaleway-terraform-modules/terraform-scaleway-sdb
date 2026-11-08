output "endpoint" {
  description = "Endpoint of the database."
  value       = scaleway_sdb_sql_database.main.endpoint
}

output "admin_connection_string" {
  description = "Connection string with read and write access to data and schema. Null if `admin` is not in `access_levels`."
  value = contains(var.access_levels, "admin") ? format("postgres://%s:%s@%s",
    scaleway_iam_application.admin[0].id,
    scaleway_iam_api_key.admin[0].secret_key,
    trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
  ) : null
  sensitive = true
}

output "ro_connection_string" {
  description = "Connection string with read access to data. Null if `ro` is not in `access_levels`."
  value = contains(var.access_levels, "ro") ? format("postgres://%s:%s@%s",
    scaleway_iam_application.ro[0].id,
    scaleway_iam_api_key.ro[0].secret_key,
    trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
  ) : null
  sensitive = true
}

output "rw_connection_string" {
  description = "Connection string with read and write access to data, without schema changes. Null if `rw` is not in `access_levels`."
  value = contains(var.access_levels, "rw") ? format("postgres://%s:%s@%s",
    scaleway_iam_application.rw[0].id,
    scaleway_iam_api_key.rw[0].secret_key,
    trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
  ) : null
  sensitive = true
}
