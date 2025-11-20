# ==============================================
# Database Module Outputs
# ==============================================

output "db_endpoint" {
  description = "Database endpoint (mock for demo)"
  value       = "country-db-${var.environment}.mock.rds.amazonaws.com:5432"
}

output "backup_bucket_name" {
  description = "S3 bucket name for database backups"
  value       = aws_s3_bucket.db_backup.id
}

output "backup_bucket_arn" {
  description = "S3 bucket ARN for database backups"
  value       = aws_s3_bucket.db_backup.arn
}

output "db_connection_url" {
  description = "JDBC connection URL for Spring Boot"
  value       = "jdbc:postgresql://country-db-${var.environment}.mock.rds.amazonaws.com:5432/countrydb"
}

output "kubernetes_secret_name" {
  description = "Name of the Kubernetes secret with DB credentials"
  value       = kubernetes_secret.db_connection.metadata[0].name
}
