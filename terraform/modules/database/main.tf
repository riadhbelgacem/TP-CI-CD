# ==============================================
# PostgreSQL Database Server (EC2 Instance)
# NOTE: RDS requires LocalStack Pro. For free LocalStack demo,
# we provision an EC2 instance to host PostgreSQL.
# In production, this would be a managed RDS instance.
# ==============================================

# EC2 instance for PostgreSQL database
resource "aws_instance" "db_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (placeholder for LocalStack)
  instance_type = var.db_instance_class
  
  tags = merge(
    var.common_tags,
    {
      Name        = "country-db-${var.environment}"
      Environment = var.environment
      Role        = "PostgreSQL Database Server"
    }
  )
}

# Security group for database access
resource "aws_security_group" "db_sg" {
  name        = "country-db-sg-${var.environment}"
  description = "Security group for PostgreSQL database server"
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict this
    description = "PostgreSQL access"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }
  
  tags = merge(
    var.common_tags,
    {
      Name        = "country-db-sg-${var.environment}"
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
    spring-datasource-url      = "jdbc:postgresql://${aws_instance.db_server.private_ip}:5432/countrydb"
    spring-datasource-username = var.db_username
    spring-datasource-password = var.db_password
  }
  
  type = "Opaque"
}
