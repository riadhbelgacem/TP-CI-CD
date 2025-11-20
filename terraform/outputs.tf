# ============================================
# Output Values
# ============================================

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.mybucket.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.mybucket.arn
}

output "bucket_region" {
  description = "The region of the S3 bucket"
  value       = aws_s3_bucket.mybucket.region
}

output "test_file_key" {
  description = "The key of the test file uploaded"
  value       = aws_s3_object.test_file.key
}

output "test_file_etag" {
  description = "The ETag of the test file"
  value       = aws_s3_object.test_file.etag
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = aws_s3_bucket_versioning.mybucket_versioning.versioning_configuration[0].status
}
