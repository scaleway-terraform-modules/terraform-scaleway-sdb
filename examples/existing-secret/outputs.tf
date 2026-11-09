output "database_endpoint" {
  description = "Endpoint of the database."
  value       = module.sdb.database_endpoint
}

output "access" {
  description = "IAM application ID, API access key and secret ID of each access level."
  value       = module.sdb.access
}
