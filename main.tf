terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Security module - creates state bucket, DynamoDB, Security Hub, GuardDuty
module "security" {
  source = "./modules/security"
  
  project_name       = var.project_name
  environment        = var.environment
  enable_securityhub = var.enable_securityhub
  enable_guardduty   = var.enable_guardduty
}

# Pipeline module - creates CodePipeline, CodeBuild, S3 artifacts
module "pipeline" {
  source = "./modules/pipeline"
  
  project_name              = var.project_name
  environment               = var.environment
  pipeline_name             = var.pipeline_name
  codebuild_role_arn        = aws_iam_role.codebuild.arn
  codepipeline_role_arn     = aws_iam_role.codepipeline.arn
  cloudformation_role_arn   = aws_iam_role.cloudformation.arn
}
