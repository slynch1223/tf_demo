module "vpc" {
  source = "./modules/vpc"

  cidr     = var.cidr_block
  vpc_name = "${var.namespace}-${var.environment}"
}

# Get active availability zone list
data "aws_availability_zones" "available" {
  state = "available"
}

# Create Public subnets
module "subnets" {
  source = "./modules/subnets"
  count  = 2

  availability_zone = index(data.aws_availability_zones.available.names, count.index)
  cidr              = cidrsubnet(var.cidr_block, 2, count.index)
  subnet_name       = "${var.namespace}-${var.environment}-public${count.index}"
  vpc_id            = module.vpc.id
}

# Create Private subnets
module "subnets" {
  source = "./modules/subnets"
  count  = 2

  availability_zone = index(data.aws_availability_zones.available.names, count.index)
  cidr              = cidrsubnet(var.cidr_block, 2, count.index + 2)
  subnet_name       = "${var.namespace}-${var.environment}-private${count.index}"
  vpc_id            = module.vpc.id
}
