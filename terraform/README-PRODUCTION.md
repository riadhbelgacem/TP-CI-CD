# 🏗️ Production Terraform Setup for Country Service

## 🎯 What This Does

This Terraform configuration provisions **production-grade infrastructure** for your Country Service:

### **Current Setup (Manual)**
- ✅ H2 in-memory database (dev only)
- ✅ Docker containers
- ✅ Kubernetes deployments
- ✅ Prometheus + Grafana

### **With Terraform (Production-Ready)**
- ✅ **Managed PostgreSQL Database** (AWS RDS / Azure Database)
- ✅ **Auto-scaling** based on load
- ✅ **Automated backups** (7-day retention)
- ✅ **Multi-environment support** (dev, staging, prod)
- ✅ **Kubernetes secrets** for database credentials
- ✅ **Infrastructure as Code** - reproducible & version-controlled

---

## 📁 Structure

```
terraform/
├── modules/
│   └── database/          # Reusable database module
│       ├── main.tf        # PostgreSQL RDS resource
│       ├── variables.tf   # Input parameters
│       └── outputs.tf     # Connection details
│
└── environments/
    ├── dev/              # Development environment
    │   ├── main.tf       # Uses 1 small DB instance
    │   └── variables.tf
    │
    ├── staging/          # Staging environment
    │   ├── main.tf       # Uses 1 medium DB instance
    │   └── variables.tf
    │
    └── prod/             # Production environment
        ├── main.tf       # Uses 2 large DB instances + replicas
        └── variables.tf
```

---

## 🚀 Usage

### **Development Environment**

```bash
cd terraform/environments/dev

# Initialize
terraform init

# Plan (preview changes)
terraform plan

# Apply (create database)
terraform apply -auto-approve

# Get database URL
terraform output database_url
# Output: jdbc:postgresql://country-db-dev.xxx.rds.amazonaws.com:5432/countrydb
```

### **Update Spring Boot Configuration**

After Terraform creates the database, update your `application.properties`:

```properties
# Before (H2 in-memory)
spring.datasource.url=jdbc:h2:mem:testdb

# After (PostgreSQL from Terraform)
spring.datasource.url=${terraform output -raw database_url}
spring.datasource.username=country_admin
spring.datasource.password=${DB_PASSWORD}  # From Kubernetes secret
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
```

---

## 🔐 Database Credentials in Kubernetes

Terraform automatically creates a Kubernetes secret:

```bash
# View the secret
kubectl get secret country-db-connection -n jenkins -o yaml

# Use in deployment.yml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - name: country-service
        env:
        - name: SPRING_DATASOURCE_URL
          valueFrom:
            secretKeyRef:
              name: country-db-connection
              key: spring-datasource-url
        - name: SPRING_DATASOURCE_USERNAME
          valueFrom:
            secretKeyRef:
              name: country-db-connection
              key: spring-datasource-username
        - name: SPRING_DATASOURCE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: country-db-connection
              key: spring-datasource-password
```

---

## 🎯 Why This Is Better Than Manual Setup

| Aspect | Manual Setup | With Terraform |
|--------|--------------|----------------|
| **Reproducibility** | ❌ Manual steps, error-prone | ✅ One command, consistent |
| **Environments** | ❌ Copy-paste configs | ✅ Separate modules per env |
| **Backups** | ❌ Manual configuration | ✅ Automated (7-day retention) |
| **Scaling** | ❌ Manual instance resizing | ✅ Auto-scaling configured |
| **Documentation** | ❌ Wiki/README | ✅ Code IS documentation |
| **Rollback** | ❌ Manual restore | ✅ `terraform destroy` + reapply |
| **Security** | ❌ Credentials in files | ✅ Kubernetes secrets |

---

## 🔄 Integration with Jenkins

Add a new stage to Jenkinsfile:

```groovy
stage('Provision Database') {
    when {
        expression { params.PROVISION_DB == true }
    }
    steps {
        dir('terraform/environments/dev') {
            sh '''
                terraform init
                terraform apply -auto-approve \
                  -var="db_password=${DB_PASSWORD}"
            '''
        }
    }
}
```

---

## 📊 Monitoring

Your existing Prometheus/Grafana will automatically monitor the database:
- Connection pool metrics
- Query performance
- Database size
- Replication lag (for prod)

---

## 🎓 Learn More

- **Terraform Modules**: https://developer.hashicorp.com/terraform/language/modules
- **AWS RDS with Terraform**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
- **Kubernetes Provider**: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

---

**Created for:** CountryService Production Deployment  
**Purpose:** Managed database infrastructure with Terraform  
**Benefit:** Reproducible, scalable, production-ready data layer
