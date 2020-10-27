provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source      = "clouddrove/vpc/aws"
  version     = "0.13.0"
  name        = "vpc"
  application = var.application
  environment = var.environment
  label_order = var.label_order

  cidr_block = var.cidr_block
}

module "subnets" {
  source      = "clouddrove/subnet/aws"
  version     = "0.13.0"
  name        = "subnet"
  application = var.application
  environment = var.environment
  label_order = var.label_order

  availability_zones  = ["${var.region}a", "${var.region}b", "${var.region}c"]
  vpc_id              = module.vpc.vpc_id
  type                = var.subnet_type
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = var.nat_gateway
  cidr_block          = module.vpc.vpc_cidr_block
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block
}



module "efs" {
  source = "./.."

  name        = "efs"
  application = var.application
  environment = var.environment
  label_order = var.label_order

  creation_token     = var.token
  region             = var.region
  availability_zones = ["${var.region}b", "${var.region}c"]
  vpc_id             = module.vpc.vpc_id
  subnets            = module.subnets.private_subnet_id
  security_groups    = [module.vpc.vpc_default_security_group_id]
}
