# ============================================
# Main Configuration
# ============================================
# This file contains the main resources for LocalStack testing

# S3 Bucket Resource
resource "aws_s3_bucket" "mybucket" {
  provider = aws.localstack
  bucket   = var.bucket_name != "" ? var.bucket_name : "my-local-bucket-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  
  lifecycle {
    prevent_destroy = false
  }
  
  force_destroy = true
  
  tags = merge(
    var.common_tags,
    {
      Name = "LocalStack Test Bucket"
    }
  )
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "mybucket_versioning" {
  provider = aws.localstack
  bucket   = aws_s3_bucket.mybucket.id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Upload a test object to S3
resource "aws_s3_object" "test_file" {
  provider = aws.localstack
  bucket   = aws_s3_bucket.mybucket.id
  key      = var.test_file_key
  content  = var.test_file_content
  
  tags = var.common_tags
}
