output "backup_bucket_name" {
  description = "S3 bucket name for database backups"
  value       = aws_s3_bucket.db_backup.id
}

output "backup_bucket_arn" {
  description = "S3 bucket ARN for database backups"
  value       = aws_s3_bucket.db_backup.arn
}

output "kubernetes_secret_name" {
  description = "Kubernetes secret name with DB credentials"
  value       = kubernetes_secret.db_connection.metadata[0].name
}

output "config_file_key" {
  description = "S3 key for database configuration file"
  value       = aws_s3_object.db_config.key
}
