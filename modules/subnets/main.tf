resource "aws_subnet" "this" {
  availability_zone = var.availability_zone
  cidr_block        = var.cidr
  vpc_id            = var.vpc_id

  tags = {
    Name = var.subnet_name
  }
}
