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

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to all resources created by this module."
}

# Module      : EFS
# Description : Terraform EFS  module variables.
variable "security_groups" {
  type        = list(string)
  description = "Security group IDs to allow access to the EFS"
}

variable "from_port" {
  type        = number
  default     = 2049
  description = "Starting port for the NFS ingress security group rule."
}

variable "to_port" {
  type        = number
  default     = 2049
  description = "Ending port for the NFS ingress security group rule."
}

variable "egress_from_port" {
  type        = number
  default     = 0
  description = "Starting port for the outbound security group rule. Ignored when `egress_protocol` is `-1`."
}
variable "egress_to_port" {
  type        = number
  default     = 0
  description = "Ending port for the outbound security group rule. Ignored when `egress_protocol` is `-1`."
}

variable "protocol" {
  type        = string
  default     = "tcp"
  description = "IP protocol for the NFS ingress security group rules."
}

variable "egress_protocol" {
  type        = string
  default     = "-1"
  description = "IP protocol for outbound traffic"
}

variable "egress_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of IPv4 CIDR blocks allowed for outbound traffic from the EFS security group."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to create this resource or not?"
}

variable "replication_enabled" {
  type        = bool
  default     = true
  description = "Set to `false` to skip creating the EFS replication configuration."
}

variable "enable_mount_target" {
  type        = bool
  default     = true
  description = "Set to `false` to skip creating the EFS mount targets."
}

variable "enable_security_group" {
  type        = bool
  default     = true
  description = "Set to `false` to skip creating the EFS security group (and its rules)."
}

variable "enable_ingress_security_group_rule" {
  type        = bool
  default     = true
  description = "Set to `false` to skip creating NFS ingress rules from the security groups in `security_groups`."
}

variable "enable_ingress_cidr_rule" {
  type        = bool
  default     = true
  description = "Set to `false` to skip creating NFS ingress rules from the CIDR blocks in `allow_cidr`."
}

variable "enable_egress_rule" {
  type        = bool
  default     = true
  description = "Set to `false` to skip creating the egress rules from `egress_cidr_blocks`."
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
  type        = number
  default     = 0
  description = "Provisioned throughput in MiB/s. Only applicable when throughput_mode is provisioned."
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
  type        = bool
  default     = true
  description = "Set to `false` to skip creating the EFS access point."
}

variable "mount_target_description" {
  type        = string
  default     = "this is mount target security group "
  description = "Description of the security group attached to the EFS mount targets."
}

variable "bypass_policy_lockout_safety_check" {
  description = "A flag to indicate whether to bypass the `aws_efs_file_system_policy` lockout safety check. Defaults to `false`"
  type        = bool
  default     = false
}

variable "enable_aws_efs_file_system_policy" {
  description = "A flag to enable or disable aws efs file system policy . Defaults to `false`"
  type        = bool
  default     = false
}

variable "replication_configuration_destination" {
  description = "A destination configuration block"
  type        = any
  default     = {}
}

variable "source_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s"
  type        = list(string)
  default     = []
}

variable "override_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`"
  type        = list(string)
  default     = []
}

variable "policy_statements" {
  description = "A list of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = any
  default     = []
}

variable "deny_nonsecure_transport" {
  description = "Determines whether `aws:SecureTransport` is required when connecting to elastic file system"
  type        = bool
  default     = false
}
