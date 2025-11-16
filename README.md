# DevSecOps Pipeline with Terraform on AWS EU Central 1

## 🏗️ Project Structure

```
devsecops-terraform/
├── README.md                    # This file
├── main.tf                      # Main Terraform configuration
├── variables.tf                 # Terraform variables
├── outputs.tf                   # Terraform outputs
├── iam.tf                       # IAM roles and policies
├── buildspec-security.yml       # CodeBuild security scanning spec
├── process_security_findings.py # Security findings processor
├── deploy.sh                    # Deployment script
├── .gitignore                   # Git ignore file
└── docs/
    ├── architecture.md          # Architecture documentation
    └── security-tools.md        # Security tools documentation
```

## 🚀 Quick Start

1. **Clone and Setup**
   ```bash
   git clone <your-repo-url>
   cd devsecops-terraform
   ```

2. **Deploy Infrastructure**
   ```bash
   ./deploy.sh
   ```

3. **Upload Source Code**
   ```bash
   aws s3 cp source.zip s3://your-artifacts-bucket/source.zip --region eu-central-1
   ```

## 🔒 Security Tools Integrated

- **SAST**: Bandit (Python), Checkov (IaC)
- **Dependency Scanning**: Safety
- **Container Scanning**: Trivy, Grype
- **Runtime Security**: GuardDuty, Security Hub
- **Compliance**: AWS Config

## 📊 Pipeline Stages

1. **Source** → Code from S3
2. **Security Scan** → Multi-tool security analysis
3. **Deploy** → CloudFormation deployment

## 🛡️ AWS Services Used

- CodePipeline, CodeBuild
- Security Hub, GuardDuty
- Inspector, Config
- S3, IAM, CloudFormation

## 📋 Prerequisites

- AWS CLI configured
- Terraform installed
- Appropriate AWS permissions

## 🌍 Region

Configured for **EU Central 1** (eu-central-1)

## 📝 License

MIT License
# DevSecOps-terraform-ci-cd-pippeline
