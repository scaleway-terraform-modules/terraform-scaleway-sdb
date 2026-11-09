output "database_endpoint" {
  description = "Endpoint of the database."
  value       = module.sdb.database_endpoint
}

output "ro_application_id" {
  description = "IAM application ID of the `ro` access level: the user name to connect to the database."
  value       = module.sdb.access["ro"].application_id
}

output "ro_secret_id" {
  description = "ID of the Secret Manager secret holding the secret key of the `ro` access level: the password to connect to the database."
  value       = module.sdb.access["ro"].secret_id
}
