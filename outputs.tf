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

output "database_endpoint" {
  description = "Endpoint of the database."
  value       = scaleway_sdb_sql_database.main.endpoint
}

output "database_id" {
  description = "ID of the database, in the `{region}/{id}` format."
  value       = scaleway_sdb_sql_database.main.id
}

output "database_name" {
  description = "Name of the database."
  value       = scaleway_sdb_sql_database.main.name
}

output "database_project_id" {
  description = "ID of the project the database is associated with."
  value       = scaleway_sdb_sql_database.main.project_id
}

output "database_region" {
  description = "Region of the database."
  value       = scaleway_sdb_sql_database.main.region
}

output "database_srn" {
  description = "Scaleway Resource Name (SRN) of the database."
  value       = scaleway_sdb_sql_database.main.srn
}

output "database_version" {
  description = "PostgreSQL major version of the database."
  value       = scaleway_sdb_sql_database.main.version
}

output "database_version_end_of_life_at" {
  description = "End of life date of the PostgreSQL version of the database (RFC 3339 format)."
  value       = scaleway_sdb_sql_database.main.version_end_of_life_at
}
