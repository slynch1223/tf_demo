resource "aws_internet_gateway" "this" {
  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

# Attach Internet Gateway to new VPC
resource "aws_internet_gateway_attachment" "this" {
  internet_gateway_id = aws_internet_gateway.this.id
  vpc_id              = var.vpc_id
}

# Get Current VPC data source
data "aws_vpc" "this" {
  id = var.vpc_id
}

# Setup Default Route table to use new Internet Gateway
resource "aws_default_route_table" "this" {
  default_route_table_id = data.aws_vpc.this.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}
