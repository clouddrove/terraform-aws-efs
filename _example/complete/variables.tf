# Region
variable "region" {
  default = "us-east-1"
}

## Tags
variable "application" {
  default = "clouddrove"
}

variable "environment" {
  default = "test"
}

variable "label_order" {
  type        = list
  default     = ["environment", "name", "application"]
  description = "label order, e.g. `name`,`application`"
}

# Network
variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_type" {
  default = "public-private"
}

variable "nat_gateway" {
  default = false
}

#EFS
variable "token" {
  default = "changeme"
}
