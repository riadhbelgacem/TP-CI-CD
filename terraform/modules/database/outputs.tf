# ==============================================
# Database Module Outputs
# ==============================================

output "db_endpoint" {
  description = "Database connection endpoint"
  value       = aws_db_instance.country_db.endpoint
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.country_db.db_name
}

output "db_connection_url" {
  description = "JDBC connection URL for Spring Boot"
  value       = "jdbc:postgresql://${aws_db_instance.country_db.endpoint}/countrydb"
}

output "kubernetes_secret_name" {
  description = "Name of the Kubernetes secret with DB credentials"
  value       = kubernetes_secret.db_connection.metadata[0].name
}
