# Security Tools Documentation

## Static Application Security Testing (SAST)

### Bandit
- **Purpose**: Python code security analysis
- **Detects**: SQL injection, hardcoded passwords, shell injection
- **Output**: JSON report with severity levels

### Checkov
- **Purpose**: Infrastructure as Code security scanning
- **Supports**: Terraform, CloudFormation, Kubernetes
- **Detects**: Misconfigurations, compliance violations

## Dependency Scanning

### Safety
- **Purpose**: Python dependency vulnerability scanning
- **Database**: PyUp.io vulnerability database
- **Detects**: Known CVEs in dependencies

## Container Security

### Trivy
- **Purpose**: Container image vulnerability scanning
- **Detects**: OS packages, language-specific packages
- **Output**: JSON vulnerability report

### Grype
- **Purpose**: Additional container and filesystem scanning
- **Features**: Multi-format support, detailed CVE information

## AWS Native Security

### Security Hub
- **Purpose**: Centralized security findings management
- **Integration**: Receives findings from all security tools
- **Features**: Compliance dashboards, automated remediation

### GuardDuty
- **Purpose**: Threat detection service
- **Monitors**: DNS logs, VPC Flow Logs, CloudTrail
- **Detects**: Malicious activity, compromised instances

### Inspector
- **Purpose**: Application security assessment
- **Scans**: EC2 instances, container images
- **Compliance**: CIS benchmarks, security best practices

## Configuration

All tools are configured in `buildspec-security.yml` and integrated with AWS Security Hub for centralized reporting.
