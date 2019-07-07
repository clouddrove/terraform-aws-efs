variable "region" {
  default = "us-east-1"
}

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

variable "cidr_block" {
  default = 10.0.0.0/16
}
