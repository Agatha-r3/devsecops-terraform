#!/bin/bash

# DevSecOps Deployment Script for EU Central 1

set -e

echo "🚀 Starting DevSecOps Pipeline Deployment in EU Central 1"

# Initialize Terraform
echo "📋 Initializing Terraform..."
terraform init

# Plan the deployment
echo "📊 Planning Terraform deployment..."
terraform plan -var="aws_region=eu-central-1"

# Apply the infrastructure
echo "🏗️ Applying Terraform configuration..."
terraform apply -var="aws_region=eu-central-1" -auto-approve

# Get outputs
echo "📤 Getting deployment outputs..."
PIPELINE_NAME=$(terraform output -raw pipeline_name)
S3_BUCKET=$(terraform output -raw artifacts_bucket)

echo "✅ Infrastructure deployed successfully!"
echo "Pipeline Name: $PIPELINE_NAME"
echo "Artifacts Bucket: $S3_BUCKET"

# Enable Security Hub
echo "🔒 Enabling AWS Security Hub..."
aws securityhub enable-security-hub --region eu-central-1 || echo "Security Hub already enabled"

# Enable GuardDuty
echo "🛡️ Enabling AWS GuardDuty..."
aws guardduty create-detector --enable --region eu-central-1 || echo "GuardDuty already enabled"

# Enable Config
echo "⚙️ Enabling AWS Config..."
aws configservice put-configuration-recorder \
    --configuration-recorder name=default,roleARN=arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig \
    --region eu-central-1 || echo "Config already configured"

echo "🎉 DevSecOps pipeline setup complete!"
echo ""
echo "Next steps:"
echo "1. Upload your source code to: s3://$S3_BUCKET/source.zip"
echo "2. The pipeline will automatically trigger security scans"
echo "3. Check Security Hub for findings: https://eu-central-1.console.aws.amazon.com/securityhub/"
echo "4. Monitor GuardDuty: https://eu-central-1.console.aws.amazon.com/guardduty/"
