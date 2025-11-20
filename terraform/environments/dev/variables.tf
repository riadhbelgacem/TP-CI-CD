# ==============================================
# Development Environment Variables
# ==============================================

variable "db_username" {
  description = "Database username for dev environment"
  type        = string
  default     = "country_admin"
  sensitive   = true
}

variable "db_password" {
  description = "Database password for dev environment"
  type        = string
  sensitive   = true
}
