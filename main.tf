terraform {
  cloud {
    organization = "lynchbros"

    workspaces {
      name = "tf_first"
    }
  }

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
      Creator      = var.creator
      Owner        = var.owner
      Organization = var.organization
      Environment  = var.environment
    }
  }
}

# module "s3_bucket" {
#   source = "github.com/slynch1223/terraform_modules/s3_bucket/"

#   bucket_name = "slynch1223-tf-"
# }

# module "vpc" {
#   source = "github.com/slynch1223/terraform_modules/vpc/"

#   cidr_block = "10.0.0.0/16"
# }
