output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.devsecops_pipeline.name
}

output "artifacts_bucket" {
  description = "S3 bucket for pipeline artifacts"
  value       = aws_s3_bucket.artifacts.bucket
}

output "codebuild_project" {
  description = "CodeBuild project for security scanning"
  value       = aws_codebuild_project.security_scan.name
}
