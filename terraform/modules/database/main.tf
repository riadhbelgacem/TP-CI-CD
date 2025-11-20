# ==============================================
# Database Infrastructure Demo with S3
# NOTE: RDS and EC2 require LocalStack Pro.
# For free LocalStack demo, we use S3 to demonstrate Terraform infrastructure provisioning.
# In production, this would be RDS or EC2-hosted database.
# ==============================================

# S3 bucket for database backups and configuration
resource "aws_s3_bucket" "db_backup" {
  bucket = "country-db-backup-${var.environment}"
  
  tags = merge(
    var.common_tags,
    {
      Name        = "country-db-backup-${var.environment}"
      Environment = var.environment
      Purpose     = "Database backups and PostgreSQL configuration"
    }
  )
}

# Enable versioning for backup safety
resource "aws_s3_bucket_versioning" "db_backup" {
  bucket = aws_s3_bucket.db_backup.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Upload a demo configuration file
resource "aws_s3_object" "db_config" {
  bucket  = aws_s3_bucket.db_backup.id
  key     = "postgresql/db-config.json"
  content = jsonencode({
    database = "countrydb"
    host     = "country-db-${var.environment}.mock.rds.amazonaws.com"
    port     = 5432
    environment = var.environment
  })
  
  tags = var.common_tags
}

# Create database connection secret for Kubernetes
resource "kubernetes_secret" "db_connection" {
  metadata {
    name      = "country-db-connection"
    namespace = var.kubernetes_namespace
  }
  
  data = {
    spring-datasource-url      = "jdbc:postgresql://country-db-${var.environment}.mock.rds.amazonaws.com:5432/countrydb"
    spring-datasource-username = var.db_username
    spring-datasource-password = var.db_password
    backup-bucket              = aws_s3_bucket.db_backup.id
  }
  
  type = "Opaque"
}
