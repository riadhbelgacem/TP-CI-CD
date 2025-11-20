# ============================================
# Input Variables
# ============================================

variable "aws_region" {
  description = "AWS region for LocalStack"
  type        = string
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  description = "LocalStack endpoint URL"
  type        = string
  default     = "http://localhost:4566"
}

variable "bucket_name" {
  description = "Name of the S3 bucket (leave empty for auto-generated name)"
  type        = string
  default     = ""
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "test_file_key" {
  description = "Key (name) of the test file to upload"
  type        = string
  default     = "test-file.txt"
}

variable "test_file_content" {
  description = "Content of the test file"
  type        = string
  default     = "This is a test file created by Terraform in LocalStack!"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    ManagedBy   = "Terraform"
    Project     = "CountryService"
  }
}
