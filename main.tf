module "vpc" {
  source = "./modules/vpc"

  cidr_block              = var.cidr_block
  enable_internet_gateway = true
  region                  = var.region
  vpc_name                = "${var.namespace}-${var.environment}"
}

module "subnets" {
  source = "./modules/subnets"

  availability_zone_count = 2
  cidr_block              = var.cidr_block
  subnet_name_prefix      = "${var.namespace}-${var.environment}"
  vpc_id                  = module.vpc.id
}
