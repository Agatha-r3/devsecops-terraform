#!/usr/bin/env python3
import json
import boto3
import os
from datetime import datetime

def send_to_security_hub(findings):
    """Send security findings to AWS Security Hub"""
    securityhub = boto3.client('securityhub', region_name=os.environ.get('AWS_DEFAULT_REGION', 'eu-central-1'))
    
    formatted_findings = []
    for finding in findings:
        formatted_finding = {
            'SchemaVersion': '2018-10-08',
            'Id': finding.get('id', 'unknown'),
            'ProductArn': f"arn:aws:securityhub:{os.environ.get('AWS_DEFAULT_REGION')}::product/custom/devsecops-scanner",
            'GeneratorId': 'devsecops-pipeline',
            'AwsAccountId': os.environ.get('AWS_ACCOUNT_ID'),
            'Types': ['Software and Configuration Checks/Vulnerabilities/CVE'],
            'CreatedAt': datetime.utcnow().isoformat() + 'Z',
            'UpdatedAt': datetime.utcnow().isoformat() + 'Z',
            'Severity': {
                'Label': finding.get('severity', 'MEDIUM').upper()
            },
            'Title': finding.get('title', 'Security Finding'),
            'Description': finding.get('description', 'Security vulnerability detected')
        }
        formatted_findings.append(formatted_finding)
    
    if formatted_findings:
        try:
            response = securityhub.batch_import_findings(Findings=formatted_findings)
            print(f"Successfully sent {len(formatted_findings)} findings to Security Hub")
        except Exception as e:
            print(f"Error sending findings to Security Hub: {e}")

def process_bandit_findings():
    """Process Bandit SAST findings"""
    findings = []
    try:
        with open('bandit-report.json', 'r') as f:
            data = json.load(f)
            for result in data.get('results', []):
                findings.append({
                    'id': f"bandit-{result.get('test_id', 'unknown')}",
                    'title': f"SAST: {result.get('test_name', 'Security Issue')}",
                    'description': result.get('issue_text', 'No description'),
                    'severity': result.get('issue_severity', 'MEDIUM').lower()
                })
    except FileNotFoundError:
        print("Bandit report not found")
    return findings

def process_safety_findings():
    """Process Safety dependency findings"""
    findings = []
    try:
        with open('safety-report.json', 'r') as f:
            data = json.load(f)
            for vuln in data:
                findings.append({
                    'id': f"safety-{vuln.get('id', 'unknown')}",
                    'title': f"Dependency Vulnerability: {vuln.get('package_name', 'Unknown')}",
                    'description': vuln.get('advisory', 'No description'),
                    'severity': 'HIGH'
                })
    except FileNotFoundError:
        print("Safety report not found")
    return findings

def process_checkov_findings():
    """Process Checkov IaC findings"""
    findings = []
    try:
        with open('checkov-report.json', 'r') as f:
            data = json.load(f)
            for result in data.get('results', {}).get('failed_checks', []):
                findings.append({
                    'id': f"checkov-{result.get('check_id', 'unknown')}",
                    'title': f"IaC: {result.get('check_name', 'Configuration Issue')}",
                    'description': result.get('description', 'No description'),
                    'severity': 'MEDIUM'
                })
    except FileNotFoundError:
        print("Checkov report not found")
    return findings

def main():
    all_findings = []
    all_findings.extend(process_bandit_findings())
    all_findings.extend(process_safety_findings())
    all_findings.extend(process_checkov_findings())
    
    print(f"Total findings: {len(all_findings)}")
    
    if all_findings:
        send_to_security_hub(all_findings)
    
    # Create summary report
    summary = {
        'total_findings': len(all_findings),
        'high_severity': len([f for f in all_findings if f.get('severity') == 'high']),
        'medium_severity': len([f for f in all_findings if f.get('severity') == 'medium']),
        'low_severity': len([f for f in all_findings if f.get('severity') == 'low'])
    }
    
    with open('security-summary.json', 'w') as f:
        json.dump(summary, f, indent=2)

if __name__ == '__main__':
    main()
