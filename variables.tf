#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Solution name, e.g. `app`"
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
  sensitive   = true
  description = "Security group IDs to allow access to the EFS"
}

variable "efs_enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "creation_token" {
  type        = string
  description = "A unique name (a maximum of 64 characters are allowed) used as reference when creating the EFS"
}

variable "vpc_id" {
  type        = string
  sensitive   = true
  description = "VPC ID"
}

variable "subnets" {
  type        = list(string)
  sensitive   = true
  description = "Subnet IDs"
}

variable "availability_zones" {
  type        = list(string)
  sensitive   = true
  description = "Availability Zone IDs"
}

variable "encrypted" {
  type        = bool
  default     = true
  description = "If true, the file system will be encrypted"

}

variable "performance_mode" {
  type        = string
  default     = "generalPurpose"
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"

}

variable "provisioned_throughput_in_mibps" {
  type        = string
  default     = 0
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned"
}

variable "throughput_mode" {
  type        = string
  default     = "bursting"
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`"

}

variable "mount_target_ip_address" {
  type        = string
  default     = null
  sensitive   = true
  description = "The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target"
}

variable "kms_key_id" {
  type        = string
  default     = ""
  sensitive   = true
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true."
}

variable "efs_backup_policy_enabled" {
  type        = bool
  default     = true
  description = "If `true`, it will turn on automatic backups."
}

variable "allow_cidr" {
  type        = list(any)
  default     = []
  description = "Provide allowed cidr to efs"
}

variable "access_point_enabled" {
  type    = bool
  default = true
}

variable "mount_target_description" {
  type    = string
  default = ""
}