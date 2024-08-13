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
  description = "Region in which the resource exists."
  type        = string
  default     = null
}
