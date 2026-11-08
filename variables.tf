variable "name" {
  description = "Name of the database."
  type        = string
}

variable "keys_ttl" {
  description = "TTL of IAM keys in days."
  type        = number
  default     = 0
}

variable "min_cpu" {
  description = "Minimum number of CPU units for your database."
  type        = number
  default     = 0
}

variable "max_cpu" {
  description = "Maximum number of CPU units for your database."
  type        = number
  default     = 15
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
