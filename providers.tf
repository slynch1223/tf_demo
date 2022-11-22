terraform {
  required_version = ">= 1.0"

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
      Environment  = var.environment
      Owner        = var.owner
      Organization = var.organization
    }
  }
}
