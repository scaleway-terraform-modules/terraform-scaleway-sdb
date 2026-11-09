variable "image" {
  description = "Image of the container, e.g. `rg.fr-par.scw.cloud/my-namespace/my-app:1.0.0`. The application reads its database connection string from the `DATABASE_URL` environment variable."
  type        = string
}
