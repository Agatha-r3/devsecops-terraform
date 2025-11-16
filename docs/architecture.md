# DevSecOps Architecture

## Architecture Diagram

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   Source    │───▶│ CodePipeline │───▶│   Deploy    │
│     S3      │    │              │    │CloudFormation│
└─────────────┘    └──────┬───────┘    └─────────────┘
                          │
                          ▼
                   ┌──────────────┐
                   │  CodeBuild   │
                   │Security Scan │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │Security Tools│
                   │ • Bandit     │
                   │ • Safety     │
                   │ • Checkov    │
                   │ • Trivy      │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │Security Hub  │
                   │  Findings    │
                   └──────────────┘
```

## Components

### 1. Source Stage
- S3 bucket stores source code
- Triggers pipeline on object upload

### 2. Security Scanning Stage
- CodeBuild project runs multiple security tools
- Parallel execution of SAST, dependency, and IaC scans
- Results aggregated and sent to Security Hub

### 3. Deployment Stage
- CloudFormation deploys infrastructure
- Only proceeds if security scans pass

## Security Integration Points

1. **Build Time**: SAST and dependency scanning
2. **Infrastructure**: IaC security validation
3. **Runtime**: GuardDuty threat detection
4. **Compliance**: Config rule monitoring
