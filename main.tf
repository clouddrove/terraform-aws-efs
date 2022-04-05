# Managed By : CloudDrove
# Description : This Script is used to create security group.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : Terraform module to create consistent naming for multiple names.

module "label" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"

  name        = var.name
  repository  = var.repository
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  enabled     = var.efs_enabled
}

#Module      : EFS
#Description : Provides a efs resource.
resource "aws_efs_file_system" "default" {
  count                           = var.efs_enabled ? 1 : 0
  creation_token                  = var.creation_token
  tags                            = module.label.tags
  encrypted                       = var.encrypted
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
  kms_key_id                      = var.kms_key_id
}

#Module      : EFS
#Description : Provides a efs resource mount target.
resource "aws_efs_mount_target" "default" {
  count           = var.efs_enabled && length(var.availability_zones) > 0 ? length(var.availability_zones) : 0
  file_system_id  = join("", aws_efs_file_system.default.*.id)
  ip_address      = var.mount_target_ip_address
  subnet_id       = var.subnets[count.index]
  security_groups = [join("", aws_security_group.default.*.id)]
}

#Module      : SECURITY GROUP
#Description : Provides a security group resource.
resource "aws_security_group" "default" {
  count       = var.efs_enabled ? 1 : 0
  name        = module.label.id
  description = "EFS"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = "2049" # NFS
    to_port         = "2049"
    protocol        = "tcp"
    security_groups = var.security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.label.tags
}

resource "aws_efs_backup_policy" "policy" {
  count = var.efs_enabled ? 1 : 0

  file_system_id = join("", aws_efs_file_system.default.*.id)

  backup_policy {
    status = var.efs_backup_policy_enabled ? "ENABLED" : "DISABLED"
  }
}
resource "aws_efs_access_point" "default" {
  count          = var.efs_enabled ? 1 : 0
  file_system_id = join("", aws_efs_file_system.default.*.id)

  tags = module.label.tags

}
