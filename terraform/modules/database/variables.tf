# ==============================================
# Database Module Variables
# ==============================================

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "db_instance_class" {
  description = "Database instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Initial storage in GB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum storage for autoscaling in GB"
  type        = number
  default     = 100
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for secrets"
  type        = string
  default     = "jenkins"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project   = "CountryService"
    ManagedBy = "Terraform"
  }
}
