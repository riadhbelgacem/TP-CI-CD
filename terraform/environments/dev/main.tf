# ==============================================
# Development Environment
# ==============================================

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Providers
provider "aws" {
  alias  = "localstack"
  region = "us-east-1"
  
  access_key = "test"
  secret_key = "test"
  
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  
  endpoints {
    rds = "http://localhost:4566"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Use the database module
module "country_database" {
  source = "../../modules/database"
  
  environment            = "dev"
  db_instance_class      = "db.t3.micro"
  db_allocated_storage   = 20
  db_max_allocated_storage = 50
  
  db_username = var.db_username
  db_password = var.db_password
  
  kubernetes_namespace = "jenkins"
  
  common_tags = {
    Environment = "Development"
    Project     = "CountryService"
    ManagedBy   = "Terraform"
  }
}

# Outputs
output "database_endpoint" {
  description = "Database endpoint for dev environment"
  value       = module.country_database.db_endpoint
}

output "database_url" {
  description = "JDBC URL for Spring Boot application.properties"
  value       = module.country_database.db_connection_url
}

output "kubernetes_secret" {
  description = "Kubernetes secret name with DB credentials"
  value       = module.country_database.kubernetes_secret_name
}
