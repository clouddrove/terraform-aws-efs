variable "region" {
  default = "us-east-1"
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-efs"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "environment" {
  default = "test"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "label order, e.g. `name`,`application`"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_type" {
  default = "public-private"
}

variable "nat_gateway" {
  default = false
}

variable "token" {
  default = "changeme"
}
