# ==============================================
# PostgreSQL Database for Country Service
# ==============================================

resource "aws_db_instance" "country_db" {
  identifier     = "country-db-${var.environment}"
  engine         = "postgres"
  engine_version = "13"
  instance_class = var.db_instance_class
  
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  
  db_name  = "countrydb"
  username = var.db_username
  password = var.db_password
  
  backup_retention_period = var.environment == "prod" ? 7 : 0
  skip_final_snapshot     = var.environment != "prod"
  
  tags = merge(
    var.common_tags,
    {
      Name        = "Country Service Database"
      Environment = var.environment
    }
  )
}

# Create database connection secret for Kubernetes
resource "kubernetes_secret" "db_connection" {
  metadata {
    name      = "country-db-connection"
    namespace = var.kubernetes_namespace
  }
  
  data = {
    spring-datasource-url      = "jdbc:postgresql://${aws_db_instance.country_db.endpoint}/countrydb"
    spring-datasource-username = var.db_username
    spring-datasource-password = var.db_password
  }
  
  type = "Opaque"
}
