variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devsecops-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "pipeline_name" {
  description = "Name of the CodePipeline"
  type        = string
  default     = "devsecops-pipeline"
}

variable "enable_guardduty" {
  description = "Enable AWS GuardDuty"
  type        = bool
  default     = true
}

variable "enable_securityhub" {
  description = "Enable AWS Security Hub"
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Enable AWS Config"
  type        = bool
  default     = true
}

variable "artifact_retention_days" {
  description = "Number of days to retain artifacts"
  type        = number
  default     = 30
}
