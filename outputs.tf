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
      secret_id      = resources.key[0].secret_id
    } if length(resources.key) > 0
  }
}

output "access" {
  description = "Credentials of each access level listed in `access_levels`: IAM application ID (the user name to connect to the database), API access key, and ID of the Secret Manager secret holding the API secret key (the password to connect to the database)."
  value       = local.access
}

output "database_endpoint" {
  description = "Endpoint of the database."
  value       = scaleway_sdb_sql_database.this.endpoint
}

output "database_id" {
  description = "ID of the database, in the `{region}/{id}` format."
  value       = scaleway_sdb_sql_database.this.id
}

output "database_name" {
  description = "Name of the database."
  value       = scaleway_sdb_sql_database.this.name
}

output "database_project_id" {
  description = "ID of the project the database is associated with."
  value       = scaleway_sdb_sql_database.this.project_id
}

output "database_region" {
  description = "Region of the database."
  value       = scaleway_sdb_sql_database.this.region
}

output "database_srn" {
  description = "Scaleway Resource Name (SRN) of the database."
  value       = scaleway_sdb_sql_database.this.srn
}

output "database_version" {
  description = "PostgreSQL major version of the database."
  value       = scaleway_sdb_sql_database.this.version
}

output "database_version_end_of_life_at" {
  description = "End of life date of the PostgreSQL version of the database (RFC 3339 format)."
  value       = scaleway_sdb_sql_database.this.version_end_of_life_at
}
