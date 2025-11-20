# ============================================
# Terraform Configuration
# ============================================
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ============================================
# AWS Provider Configuration for LocalStack
# ============================================
provider "aws" {
  alias  = "localstack"
  region = var.aws_region
  
  # Fake credentials for LocalStack (not used in production)
  access_key = "test"
  secret_key = "test"
  
  # Skip AWS validation checks (LocalStack doesn't need real validation)
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  
  # LocalStack endpoints
  endpoints {
    s3  = var.localstack_endpoint
    ec2 = var.localstack_endpoint
  }
  
  # Required for LocalStack S3
  s3_use_path_style = true
}
