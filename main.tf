terraform {
  // Stripped out so I can use local state for testing
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
      Environment  = var.environment // keeping things alphabetical
      Owner        = var.owner
      Organization = var.organization
    }
  }
}


module "vpc" {
  source = "./modules/vpc"

  cidr = "10.0.0.0/16"
  name = "ml-demo"
}
