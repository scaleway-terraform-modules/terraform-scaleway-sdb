variable "name" {
  description = "Name of the database. Changing it recreates the database, and its data is lost."
  type        = string
}

variable "keys_ttl" {
  description = "TTL of IAM keys in days."
  type        = number
  default     = 0
  nullable    = false

  validation {
    condition     = var.keys_ttl >= 0 && var.keys_ttl == floor(var.keys_ttl)
    error_message = "'keys_ttl' must be a non-negative whole number of days."
  }
}

variable "min_cpu" {
  description = "Minimum number of CPU units for your database."
  type        = number
  default     = 0
  nullable    = false

  validation {
    condition     = var.min_cpu >= 0 && var.min_cpu <= 15
    error_message = "'min_cpu' must be between 0 and 15."
  }
}

variable "max_cpu" {
  description = "Maximum number of CPU units for your database."
  type        = number
  default     = 15
  nullable    = false

  validation {
    condition     = var.max_cpu >= 0 && var.max_cpu <= 15
    error_message = "'max_cpu' must be between 0 and 15."
  }

  validation {
    condition     = var.max_cpu >= var.min_cpu
    error_message = "'max_cpu' must be greater than or equal to 'min_cpu'."
  }
}

variable "region" {
  description = "Region in which the database should be created, e.g. `fr-par`. Resource will be created in the region set at the provider level if null. Changing it recreates the database, and its data is lost."
  type        = string
  default     = null
}

variable "keys_rotation_window" {
  description = "Number of days before the expiry of the IAM keys during which Terraform replaces them. Rotation only happens when Terraform runs: apply the module at least once during this window, or the keys expire. Ignored when `keys_ttl` is 0."
  type        = number
  default     = 7
  nullable    = false

  validation {
    condition     = var.keys_rotation_window >= 0 && floor(var.keys_rotation_window) == var.keys_rotation_window
    error_message = "'keys_rotation_window' must be an integer greater than or equal to 0."
  }

  validation {
    condition     = coalesce(var.keys_ttl, 0) <= 0 || var.keys_rotation_window < var.keys_ttl
    error_message = "'keys_rotation_window' must be lower than 'keys_ttl'."
  }
}

variable "project_id" {
  description = "ID of the project the database is associated with. Resource will be created in the project set at the provider level if null. Changing it recreates the database, and its data is lost."
  type        = string
  default     = null
}

variable "access_levels" {
  description = "Access levels to create an IAM application, policy and API key for, among `admin`, `rw` and `ro`. The secret key of each API key is stored in the Secret Manager secret given by `secret_id` (UUID or `{region}/{id}`; the module only adds versions to it), or in a secret created by the module when `secret_id` is null. `secret_id` must be known at plan time: it can't come from a resource created in the same apply. Each key rotation adds a version to the secret, and a secret holds 20 versions at most: the module deletes old versions of the secrets it creates, but not of the ones given by `secret_id`. Removing a level deletes its API key, and the secret created for it. Changing `secret_id` recreates the API key."
  type = map(object({
    secret_id = optional(string)
  }))
  default  = { admin = {}, rw = {}, ro = {} }
  nullable = false

  validation {
    condition     = alltrue([for level in keys(var.access_levels) : contains(["admin", "rw", "ro"], level)])
    error_message = "The keys of 'access_levels' must be among 'admin', 'rw' and 'ro'."
  }

  validation {
    condition     = alltrue([for level in values(var.access_levels) : level.secret_id == null || can(regex("^([a-z]{2}-[a-z]{3}/)?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", level.secret_id))])
    error_message = "Each 'secret_id' of 'access_levels' must be a secret ID, as a UUID or a regional ID ('{region}/{id}')."
  }
}

variable "postgresql_version" {
  description = "PostgreSQL major version of the database, e.g. `16`. The API's default version is used when null. Changing it recreates the database, and its data is lost: see the README to upgrade."
  type        = string
  default     = null
}

variable "key_secrets_path" {
  description = "Path of the Secret Manager secrets created for the secret keys. Defaults to `/sdb/<name>` when null."
  type        = string
  default     = null

  validation {
    condition     = var.key_secrets_path == null || startswith(coalesce(var.key_secrets_path, "/"), "/")
    error_message = "'key_secrets_path' must start with '/'."
  }
}
