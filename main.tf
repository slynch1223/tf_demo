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
      Owner        = var.owner
      Organization = var.organization
      Environment  = var.environment
    }
  }
}


module "vpc" {
  source = "./modules/vpc"

  cidr = "10.0.0.0/16"
  name = "sl-demo"
}
