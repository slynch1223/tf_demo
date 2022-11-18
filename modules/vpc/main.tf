resource "aws_vpc" "this" {
  cidr_block         = var.cidr
  enable_dns_support = true
  instance_tenancy   = "default"

  tags = {
    "Name" = var.name
  }
}

# Ensure traffic is restricted in Default Security Group
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
}

# Create new IAM Role for Flow Logs
resource "aws_iam_role" "this" {
  name = "${var.name}-flow-logs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach policy to new IAM Role
resource "aws_iam_role_policy" "this" {
  name = "${var.name}-flow-logs"
  role = aws_iam_role.this.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Create KMS Key to encrypt Flow Logs
resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt our VPC Flow Logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Register new Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.name}-flow-logs"
  kms_key_id        = aws_kms_key.this.id
  retention_in_days = 7
}

# Enable Flow Logs
resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.this.arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
}
