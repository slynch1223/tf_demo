variable "bucket_prefix" {
  description = "Specify a prefix for new S3 Bucket."
  type        = string

  validation {
    condition     = can(regex("[0-9a-z]", var.bucket_prefix))
    error_message = "Must be a valid string."
  }
}

# Get current user Identity
data "aws_caller_identity" "current" {}
