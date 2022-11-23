# Get active availability zone list
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count = var.availability_zone_count

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.availability_zone_count, 2)) + 1, count.index)
  vpc_id            = var.vpc_id

  tags = {
    Name = "${var.subnet_name_prefix}-public-${substr(data.aws_availability_zones.available.names[count.index], -1, 1)}"
  }
}

resource "aws_subnet" "private" {
  count = var.availability_zone_count

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.availability_zone_count, 2)) + 1, count.index + var.availability_zone_count)
  vpc_id            = var.vpc_id

  tags = {
    Name = "${var.subnet_name_prefix}-private-${substr(data.aws_availability_zones.available.names[count.index], -1, 1)}"
  }
}
