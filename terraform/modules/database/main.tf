# S3 bucket for Country Service backups
resource "aws_s3_bucket" "db_backup" {
  bucket = "country-db-backup-${var.environment}"
  force_destroy = true
  
  tags = merge(
    var.common_tags,
    {
      Name        = "country-db-backup-${var.environment}"
      Environment = var.environment
      Purpose     = "Database backups"
    }
  )
}

resource "aws_s3_bucket_versioning" "db_backup" {
  bucket = aws_s3_bucket.db_backup.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "db_config" {
  bucket  = aws_s3_bucket.db_backup.id
  key     = "config/database.json"
  content = jsonencode({
    database    = "countrydb"
    environment = var.environment
    port        = 5432
  })
  
  tags = var.common_tags
}

resource "kubernetes_secret" "db_connection" {
  metadata {
    name      = "country-db-connection"
    namespace = var.kubernetes_namespace
  }
  
  data = {
    db-username    = var.db_username
    db-password    = var.db_password
    backup-bucket  = aws_s3_bucket.db_backup.id
  }
  
  type = "Opaque"
}
