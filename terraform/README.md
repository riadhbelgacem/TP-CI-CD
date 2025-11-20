# 🏗️ Terraform + LocalStack Infrastructure Testing

Local AWS infrastructure testing for CountryService CI/CD pipeline.

## 📁 Structure

```
terraform/
├── main.tf              # S3 bucket resources
├── providers.tf         # AWS provider configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── docker-compose.yml   # LocalStack container
└── README.md           # This file
```

##  Quick Start

### Prerequisites

- Docker installed and running
- Terraform CLI (`choco install terraform`)
- AWS CLI (`choco install awscli`)

### Run Locally

```bash
# Start LocalStack
docker-compose up -d

# Initialize Terraform
terraform init

# Apply configuration
terraform apply -auto-approve

# Test with AWS CLI
aws --endpoint-url=http://localhost:4566 s3 ls

# Cleanup
terraform destroy -auto-approve
docker-compose down
```

## 🔧 Variables

Override defaults at runtime:

```bash
# Custom bucket name
terraform apply -var="bucket_name=my-bucket"

# Disable versioning
terraform apply -var="enable_versioning=false"
```

## � What Gets Created

- **S3 Bucket** with versioning
- **Test Object** uploaded to bucket
- **Tags** for organization

## 🎯 Jenkins Integration

This configuration runs automatically in the Jenkins pipeline:

**Stage:** `Test Infrastructure with Terraform`

**Steps:**
1. Start LocalStack container
2. Initialize Terraform
3. Apply configuration (create S3 bucket)
4. Test with AWS CLI
5. Destroy resources
6. Stop LocalStack

##  Troubleshooting

```bash
# Check LocalStack is running
curl http://localhost:4566/_localstack/health

# View Terraform state
terraform show

# List resources
terraform state list

# Clean Terraform cache
rm -rf .terraform
terraform init
```

---

**Purpose:** Local AWS infrastructure testing  
**Tools:** Terraform + LocalStack + Docker
