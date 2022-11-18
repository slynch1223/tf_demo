terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.15"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
      Purpose     = "TF State Files ${var.environment}"
    }
  }
}

# Get current user Identity
data "aws_caller_identity" "current" {}

module "tf_state_bucket" {
  source = "./modules/tf_state_bucket/"

  # Required Parameters
  bucket_prefix = "tf-state-files-${var.environment}-"
}
