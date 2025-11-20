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

provider "aws" {
  region = "us-east-1"
  
  access_key = "test"
  secret_key = "test"
  
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true
  
  endpoints {
    s3 = "http://localhost:4566"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "country_database" {
  source = "../../modules/database"
  
  environment          = "dev"
  db_username          = var.db_username
  db_password          = var.db_password
  kubernetes_namespace = "jenkins"
  
  common_tags = {
    Environment = "Development"
    Project     = "CountryService"
    ManagedBy   = "Terraform"
  }
}

output "backup_bucket" {
  value = module.country_database.backup_bucket_name
}

output "kubernetes_secret" {
  value = module.country_database.kubernetes_secret_name
}
