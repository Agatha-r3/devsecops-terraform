terraform {
  backend "s3" {
    bucket         = "devsecops-terraform-state-eu-central-1"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
