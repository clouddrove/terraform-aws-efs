#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  description = "Solution name, e.g. `app`"
}

variable "repository" {
  type        = string
  default     = "https://registry.terraform.io/modules/clouddrove/subnet/aws/0.14.0"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "environment" {
  type        = string
  default     = "test"
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "label order, e.g. `name`,`application`"
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

# Module      : EFS
# Description : Terraform EFS  module variables.
variable "security_groups" {
  type        = list(string)
  description = "Security group IDs to allow access to the EFS"
  sensitive   = true
}

variable "efs_enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}

variable "creation_token" {
  type        = string
  description = "A unique name (a maximum of 64 characters are allowed) used as reference when creating the EFS"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
  sensitive   = true
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zone IDs"
  sensitive   = true
}

variable "zone_id" {
  type        = string
  description = "Route53 DNS zone ID"
  default     = ""
  sensitive   = true
}

variable "delimiter" {
  type        = string
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
  default     = "-"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (e.g. `1`)"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `{ BusinessUnit = \"XYZ\" }`"
  default     = {}
}

variable "encrypted" {
  type        = bool
  description = "If true, the file system will be encrypted"
  default     = false
}

variable "performance_mode" {
  type        = string
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  default     = 0
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned"
}

variable "throughput_mode" {
  type        = string
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`"
  default     = "bursting"
}

variable "mount_target_ip_address" {
  type        = string
  description = "The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target"
  default     = ""
  sensitive   = true
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true."
  default     = ""
  sensitive   = true
}