provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git?ref=master"

  name        = "vpc"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  cidr_block = "10.0.0.0/16"
}


module "subnets" {
  source = "git::https://github.com/clouddrove/terraform-aws-subnet.git"

  application = "clouddrove"
  environment = "test"
  name        = "subnet"
  label_order = ["environment", "name", "application"]

  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id              = module.vpc.vpc_id
  type                = "public-private"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = "true"
  cidr_block          = module.vpc.vpc_cidr_block
}

module "efs" {
  source = "git::https://github.com/clouddrove/terraform-aws-efs.git"

  name        = "vpc"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  creation_token     = "tokename"
  region             = "us-east-1"
  availability_zones = ["us-east-1b", "us-east-1c"]
  vpc_id             = module.vpc.vpc_id
  subnets            = module.subnets.private_subnet_ids
  security_groups    = [module.vpc.vpc_default_security_group_id]
}
