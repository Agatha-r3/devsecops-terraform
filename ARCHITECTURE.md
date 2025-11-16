# DevSecOps Pipeline Architecture - Step by Step

## Complete Architecture Flow

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                           DEVSECOPS PIPELINE ARCHITECTURE                          │
│                                EU CENTRAL 1                                        │
└─────────────────────────────────────────────────────────────────────────────────────┘

STEP 1: SOURCE & TRIGGER
┌─────────────┐    ┌──────────────┐    ┌─────────────────┐
│  Developer  │───▶│   Git Push   │───▶│   S3 Bucket     │
│    Code     │    │   to Repo    │    │   (Artifacts)   │
└─────────────┘    └──────────────┘    └─────────┬───────┘
                                                 │
                                                 ▼
STEP 2: PIPELINE TRIGGER                ┌─────────────────┐
                                        │  CodePipeline   │◀─── CloudWatch Events
                                        │   (Triggered)   │
                                        └─────────┬───────┘
                                                  │
                                                  ▼
STEP 3: SECURITY SCANNING STAGE         ┌─────────────────┐
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
STEP 4: SECURITY FINDINGS PROCESSING    ┌─────────────────┐
                                        │    Python       │
                                        │   Processor     │
                                        │ (Aggregation)   │
                                        └─────────┬───────┘
                                                  │
                                                  ▼
STEP 5: CENTRALIZED SECURITY            ┌─────────────────┐
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
STEP 6: DEPLOYMENT GATE                 ┌─────────────────┐
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
STEP 7: INFRASTRUCTURE DEPLOYMENT       ┌─────────────────┐
                                        │ CloudFormation  │
                                        │   Deployment    │
                                        └─────────┬───────┘
                                                  │
                                                  ▼
STEP 8: RUNTIME MONITORING              ┌─────────────────┐
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

STEP 9: FEEDBACK LOOP                   ┌─────────────────┐
                                        │   Dashboard     │
                                        │   & Alerts      │
                                        └─────────────────┘
```

## Step-by-Step Process

### Step 1: Source Code Management
- Developer commits code to repository
- Code is packaged and uploaded to S3 artifacts bucket

### Step 2: Pipeline Activation
- CodePipeline detects new artifacts in S3
- Pipeline automatically triggers security scanning stage

### Step 3: Multi-Tool Security Scanning
- **SAST**: Bandit scans Python code for security vulnerabilities
- **Dependency**: Safety checks for vulnerable dependencies
- **IaC**: Checkov validates Terraform configurations
- **Container**: Trivy scans container images for CVEs
- **Additional**: Grype provides supplementary vulnerability scanning

### Step 4: Security Findings Aggregation
- Python processor collects all security tool outputs
- Findings are normalized and formatted for Security Hub
- Severity levels and metadata are standardized

### Step 5: Centralized Security Management
- All findings sent to AWS Security Hub
- GuardDuty monitors for runtime threats
- Config ensures compliance with security policies
- Inspector performs application security assessments

### Step 6: Security Gate Decision
- Pipeline evaluates security scan results
- High/Critical vulnerabilities can block deployment
- Security policies determine pass/fail criteria

### Step 7: Infrastructure Deployment
- If security checks pass, CloudFormation deploys infrastructure
- Infrastructure as Code ensures consistent, secure deployments

### Step 8: Runtime Security Monitoring
- GuardDuty continuously monitors for threats
- Config tracks configuration compliance
- CloudWatch provides operational monitoring
- X-Ray enables distributed tracing

### Step 9: Continuous Feedback
- Security dashboards provide visibility
- Automated alerts notify teams of issues
- Metrics drive continuous improvement

## Security Integration Points

- **Build Time**: SAST, dependency scanning, IaC validation
- **Deploy Time**: Security gate, compliance checks
- **Runtime**: Threat detection, configuration monitoring
- **Continuous**: Vulnerability management, compliance reporting
