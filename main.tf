terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.23.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "tf_first" {
  #checkov:skip=CKV_AWS_144:Not needed for testing
  #checkov:skip=CKV_AWS_18:Not needed for testing
  bucket_prefix = "slynch1223-tf-"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "tf_first" {
  bucket = aws_s3_bucket.tf_first.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_first" {
  bucket = aws_s3_bucket.tf_first.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "tf_first" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_first" {
  bucket = aws_s3_bucket.tf_first.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tf_first.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
