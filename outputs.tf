locals {
  access_resources = {
    admin = { application = scaleway_iam_application.admin, key = scaleway_iam_api_key.admin }
    rw    = { application = scaleway_iam_application.rw, key = scaleway_iam_api_key.rw }
    ro    = { application = scaleway_iam_application.ro, key = scaleway_iam_api_key.ro }
  }

  # Credentials of the access levels listed in `access_levels`.
  access = {
    for level, resources in local.access_resources : level => {
      application_id = resources.application[0].id
      access_key     = resources.key[0].access_key
      secret_key     = resources.key[0].secret_key
    } if length(resources.key) > 0
  }
}

output "access" {
  description = "Credentials of each access level listed in `access_levels`: IAM application ID (the user name in the connection strings), API access key, and API secret key (the password in the connection strings)."
  value       = local.access
  sensitive   = true
}

output "connection_strings" {
  description = "Connection string of each access level listed in `access_levels`."
  value = {
    for level, access in local.access : level => format("postgres://%s:%s@%s",
      access.application_id,
      access.secret_key,
      trimprefix(scaleway_sdb_sql_database.main.endpoint, "postgres://"),
    )
  }
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
