# Create new VPC
resource "aws_vpc" "this" {
  cidr_block         = var.cidr_block
  enable_dns_support = var.enable_dns_support
  instance_tenancy   = var.instance_tenancy

  tags = {
    Name = var.vpc_name
  }
}

module "vpc_flow_logs" {
  source = "./modules/vpc_flow_logs"

  name_prefix = var.vpc_name
  region      = var.region
  vpc_id      = aws_vpc.this.id
}

module "internet_gateway" {
  count  = var.enable_internet_gateway ? 1 : 0
  source = "./modules/internet_gateway"

  name_prefix = var.vpc_name
  vpc_id      = aws_vpc.this.id
}


# Block all Ingress traffic in Default Security Group except for 443
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 443
    to_port   = 443
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
