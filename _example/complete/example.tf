provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git"

  name        = "vpc"
  application = var.application
  environment = var.environment
  label_order = var.label_order

  cidr_block = var.cidr_block
}


module "subnets" {
  source = "git::https://github.com/clouddrove/terraform-aws-subnet.git"

  name        = "subnet"
  application = var.application
  environment = var.environment
  label_order = var.label_order

  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id              = module.vpc.vpc_id
  type                = "public-private"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = "true"
  cidr_block          = module.vpc.vpc_cidr_block
}

module "efs" {
  source = "git::https://github.com/clouddrove/terraform-aws-efs.git"

  name        = "efs"
  application = var.application
  environment = var.environment
  label_order = var.label_order

  creation_token     = "tokename"
  region             = var.region
  availability_zones = ["${var.region}b", "${var.region}c"]
  vpc_id             = module.vpc.vpc_id
  subnets            = module.subnets.private_subnet_id
  security_groups    = module.vpc.vpc_default_security_group_id
}
