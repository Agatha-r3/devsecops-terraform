# DevSecOps Pipeline Architecture - Step by Step

## Complete Architecture Flow with Terraform Modules

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                    DEVSECOPS PIPELINE ARCHITECTURE (MODULAR)                       │
│                                EU CENTRAL 1                                        │
└─────────────────────────────────────────────────────────────────────────────────────┘

TERRAFORM STATE MANAGEMENT
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  ┌─────────────┐    ┌──────────────┐    ┌─────────────────┐                        │
│  │ S3 Backend  │───▶│  DynamoDB    │───▶│  State Locking  │                        │
│  │(terraform.  │    │   Table      │    │   & Versioning  │                        │
│  │ tfstate)    │    │              │    │                 │                        │
│  └─────────────┘    └──────────────┘    └─────────────────┘                        │
└─────────────────────────────────────────────────────────────────────────────────────┘

STEP 1: SOURCE & TRIGGER
┌─────────────┐    ┌──────────────┐    ┌─────────────────┐
│  Developer  │───▶│   Git Push   │───▶│   S3 Bucket     │
│    Code     │    │   to Repo    │    │   (Artifacts)   │
└─────────────┘    └──────────────┘    └─────────┬───────┘
                                                 │
                                                 ▼
STEP 2: TERRAFORM MODULES DEPLOYMENT    ┌─────────────────┐
┌─────────────────────────────────────▶ │  SECURITY       │
│                                       │   MODULE        │
│  ┌─────────────┐  ┌─────────────┐    │ • Security Hub  │
│  │ Security    │  │  Pipeline   │    │ • GuardDuty     │
│  │  Module     │  │   Module    │    │ • State Bucket  │
│  └─────────────┘  └─────────────┘    │ • DynamoDB Lock │
│                                       └─────────┬───────┘
│                                                 │
│                                                 ▼
│                                       ┌─────────────────┐
│                                       │  PIPELINE       │
│                                       │   MODULE        │
│                                       │ • CodePipeline  │
│                                       │ • CodeBuild     │
│                                       │ • S3 Artifacts  │
│                                       └─────────┬───────┘
└─────────────────────────────────────────────────┘
                                                  │
                                                  ▼
STEP 3: PIPELINE TRIGGER                ┌─────────────────┐
                                        │  CodePipeline   │◀─── CloudWatch Events
                                        │   (Triggered)   │
                                        └─────────┬───────┘
                                                  │
                                                  ▼
STEP 4: SECURITY SCANNING STAGE         ┌─────────────────┐
┌─────────────────────────────────────▶ │   CodeBuild     │
│                                       │ Security Scan   │
│  ┌─────────────┐  ┌─────────────┐    │    Project      │
│  │   Bandit    │  │   Safety    │    └─────────┬───────┘
│  │   (SAST)    │  │(Dependency) │              │
│  └─────────────┘  └─────────────┘              │
│                                                 │
│  ┌─────────────┐  ┌─────────────┐              │
│  │  Checkov    │  │   Trivy     │              │
│  │   (IaC)     │  │(Container)  │              │
│  └─────────────┘  └─────────────┘              │
│                                                 │
│  ┌─────────────┐  ┌─────────────┐              │
│  │   Grype     │  │   Custom    │              │
│  │(Additional) │  │   Tests     │              │
│  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────┘
                                                  │
                                                  ▼
STEP 5: SECURITY FINDINGS PROCESSING    ┌─────────────────┐
                                        │    Python       │
                                        │   Processor     │
                                        │ (Aggregation)   │
                                        └─────────┬───────┘
                                                  │
                                                  ▼
STEP 6: CENTRALIZED SECURITY            ┌─────────────────┐
┌─────────────────────────────────────▶ │ Security Hub    │
│                                       │   (Findings)    │
│  ┌─────────────┐  ┌─────────────┐    └─────────────────┘
│  │ GuardDuty   │  │   Config    │
│  │(Threat Det.)│  │(Compliance) │
│  └─────────────┘  └─────────────┘
│
│  ┌─────────────┐  ┌─────────────┐
│  │ Inspector   │  │ CloudTrail  │
│  │(App Assess.)│  │(API Logs)   │
│  └─────────────┘  └─────────────┘
└─────────────────────────────────────────────────┘
                                                  │
                                                  ▼
STEP 7: DEPLOYMENT GATE                 ┌─────────────────┐
                                        │  Security Gate  │
                                        │ (Pass/Fail)     │
                                        └─────────┬───────┘
                                                  │
                                         ┌────────▼────────┐
                                         │   PASS?         │
                                         └────────┬────────┘
                                                  │
                                         ┌────────▼────────┐
                                         │      YES        │
                                         └────────┬────────┘
                                                  │
                                                  ▼
STEP 8: INFRASTRUCTURE DEPLOYMENT       ┌─────────────────┐
                                        │ CloudFormation  │
                                        │   Deployment    │
                                        └─────────┬───────┘
                                                  │
                                                  ▼
STEP 9: RUNTIME MONITORING              ┌─────────────────┐
┌─────────────────────────────────────▶ │   Production    │
│                                       │  Environment    │
│  ┌─────────────┐  ┌─────────────┐    └─────────────────┘
│  │ GuardDuty   │  │   Config    │
│  │(Runtime)    │  │(Continuous) │
│  └─────────────┘  └─────────────┘
│
│  ┌─────────────┐  ┌─────────────┐
│  │ CloudWatch  │  │   X-Ray     │
│  │(Monitoring) │  │(Tracing)    │
│  └─────────────┘  └─────────────┘
└─────────────────────────────────────────────────┘

STEP 10: FEEDBACK LOOP                  ┌─────────────────┐
                                        │   Dashboard     │
                                        │   & Alerts      │
                                        └─────────────────┘
```

## Terraform Module Structure

```
devsecops-terraform/
├── main.tf                      # Module orchestration
├── backend.tf                   # S3 + DynamoDB state management
├── terraform.tfvars             # Environment configuration
├── variables.tf                 # Input variables
├── outputs.tf                   # Module outputs
├── iam.tf                       # IAM roles and policies
├── modules/
│   ├── security/                # Security services module
│   │   ├── main.tf             # Security Hub, GuardDuty, state bucket
│   │   ├── variables.tf        # Security module variables
│   │   └── outputs.tf          # Security module outputs
│   └── pipeline/               # CI/CD pipeline module
│       ├── main.tf             # CodePipeline, CodeBuild, S3
│       ├── variables.tf        # Pipeline module variables
│       └── outputs.tf          # Pipeline module outputs
└── buildspec-security.yml       # Security scanning configuration
```

## Step-by-Step Process (Updated)

### Step 1: Source Code Management
- Developer commits code to repository
- Code is packaged and uploaded to S3 artifacts bucket

### Step 2: Terraform Infrastructure Deployment
- **Security Module**: Deploys Security Hub, GuardDuty, state bucket, DynamoDB lock table
- **Pipeline Module**: Deploys CodePipeline, CodeBuild, S3 artifacts bucket
- **State Management**: S3 backend with DynamoDB locking ensures safe concurrent operations

### Step 3: Pipeline Activation
- CodePipeline detects new artifacts in S3
- Pipeline automatically triggers security scanning stage

### Step 4: Multi-Tool Security Scanning
- **SAST**: Bandit scans Python code for security vulnerabilities
- **Dependency**: Safety checks for vulnerable dependencies
- **IaC**: Checkov validates Terraform configurations
- **Container**: Trivy scans container images for CVEs
- **Additional**: Grype provides supplementary vulnerability scanning

### Step 5: Security Findings Aggregation
- Python processor collects all security tool outputs
- Findings are normalized and formatted for Security Hub
- Severity levels and metadata are standardized

### Step 6: Centralized Security Management
- All findings sent to AWS Security Hub (deployed via Security Module)
- GuardDuty monitors for runtime threats (deployed via Security Module)
- Config ensures compliance with security policies
- Inspector performs application security assessments

### Step 7: Security Gate Decision
- Pipeline evaluates security scan results
- High/Critical vulnerabilities can block deployment
- Security policies determine pass/fail criteria

### Step 8: Infrastructure Deployment
- If security checks pass, CloudFormation deploys infrastructure
- Infrastructure as Code ensures consistent, secure deployments

### Step 9: Runtime Security Monitoring
- GuardDuty continuously monitors for threats
- Config tracks configuration compliance
- CloudWatch provides operational monitoring
- X-Ray enables distributed tracing

### Step 10: Continuous Feedback
- Security dashboards provide visibility
- Automated alerts notify teams of issues
- Metrics drive continuous improvement

## Key Improvements with Modular Architecture

1. **State Management**: S3 backend with DynamoDB locking prevents state corruption
2. **Modularity**: Separate security and pipeline modules for better organization
3. **Reusability**: Modules can be reused across environments
4. **Maintainability**: Clear separation of concerns
5. **Scalability**: Easy to add new modules or modify existing ones
6. **Configuration Management**: terraform.tfvars for environment-specific settings
