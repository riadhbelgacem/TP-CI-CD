# ==============================================
# Database Module Outputs
# ==============================================

output "db_endpoint" {
  description = "Database server private IP"
  value       = "${aws_instance.db_server.private_ip}:5432"
}

output "db_instance_id" {
  description = "EC2 instance ID hosting the database"
  value       = aws_instance.db_server.id
}

output "db_connection_url" {
  description = "JDBC connection URL for Spring Boot"
  value       = "jdbc:postgresql://${aws_instance.db_server.private_ip}:5432/countrydb"
}

output "kubernetes_secret_name" {
  description = "Name of the Kubernetes secret with DB credentials"
  value       = kubernetes_secret.db_connection.metadata[0].name
}

output "security_group_id" {
  description = "Security group ID for database access"
  value       = aws_security_group.db_sg.id
}
