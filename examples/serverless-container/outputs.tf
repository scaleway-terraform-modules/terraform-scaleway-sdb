output "container_domain_name" {
  description = "Domain name of the container."
  value       = scaleway_container.app.domain_name
}
