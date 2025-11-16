output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = module.pipeline.pipeline_name
}

output "artifacts_bucket" {
  description = "S3 bucket for pipeline artifacts"
  value       = module.pipeline.artifacts_bucket
}

output "codebuild_project" {
  description = "CodeBuild project for security scanning"
  value       = module.pipeline.codebuild_project
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}
