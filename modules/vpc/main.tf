resource "aws_vpc" "this" {
  cidr_block         = var.cidr
  enable_dns_support = true      // In a module this should be parameterized unless you want to enforce everyone to use this
  instance_tenancy   = "default" // In a module this should be parameterized unless you want to enforce everyone to use this

  // What about the other properties we may want to define? dns_hostnames? IPAM?

  tags = {
    "Name" = var.name // Might want to consider a way to make this unique since its in a module
  }
}

# Ensure traffic is restricted in Default Security Group
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
}

## Convention is to use dedicated resources instead of embedding policy docs
data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

# Create new IAM Role for Flow Logs
resource "aws_iam_role" "this" {
  name_prefix        = "${var.name}-flow-logs"                        // I recommend not specifying a name but instead using prefix to support future updates in place
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json // See above resource
}

# Attach policy to new IAM Role
resource "aws_iam_role_policy" "this" {
  name = "${var.name}-flow-logs"
  role = aws_iam_role.this.id

  // We should try to avoid using <<EOF since Terraform now supports jsonencode
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "GrantCloudWatchLogs"
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        // We don't need these permissions
        # "logs:DescribeLogGroups",
        # "logs:DescribeLogStreams"
      ]
      Resource = aws_cloudwatch_log_group.this.arn // Should not be *
    }]
  })
}

# Get Current Account Id needed to build ARN below
data "aws_caller_identity" "current" {}

# A KMS Key policy is required to grant access to CloudWatch Logs
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid     = "Enable IAM User Permissions" //  Allows us to manage the Key
    effect  = "Allow"
    actions = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
  statement {
    sid    = "Enable CloudWatch Logs"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    principals {
      type        = "Service"
      identifiers = ["logs.us-east-1.amazonaws.com"] // We should not hardcode the region but pass in a var instead, I am just lazy
    }
    resources = ["*"] // Since the Principal is generic across all AWS Accounts we need a condition block to isolate to our account only
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"] // Replace the region with a var again
    }
  }
}

# Create KMS Key to encrypt Flow Logs
resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt our VPC Flow Logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
}

# Register new Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  name_prefix       = "${var.name}-flow-logs" // We should use unique names
  kms_key_id        = aws_kms_key.this.arn    // Should be ARN based on documentation
  retention_in_days = 7
}

# Enable Flow Logs
resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.this.arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
}
