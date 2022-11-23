resource "aws_vpc" "this" {
  cidr_block         = var.cidr_block
  enable_dns_support = var.enable_dns_support
  instance_tenancy   = var.instance_tenancy

  tags = {
    Name = var.vpc_name
  }
}

# Ensure traffic is restricted in Default Security Group
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
}

# Create Trust Policy to enable role usage
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
  name_prefix        = "${var.vpc_name}-flow-logs"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

# Attach policy to new IAM Role
resource "aws_iam_role_policy" "this" {
  name = "${var.vpc_name}-flow-logs"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "GrantCloudWatchLogs"
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = aws_cloudwatch_log_group.this.arn
    }]
  })
}

# Get current user
data "aws_caller_identity" "current" {}

# A KMS Key policy is required to grant access to CloudWatch Logs
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid     = "Enable IAM User Permissions"
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
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
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
  name_prefix       = "${var.vpc_name}-flow-logs"
  kms_key_id        = aws_kms_key.this.arn
  retention_in_days = 7
}

# Enable Flow Logs
resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.this.arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
}
