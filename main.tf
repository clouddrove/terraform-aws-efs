# Managed By : CloudDrove
# Description : This Script is used to create security group.
# Copyright @ CloudDrove. All Right Reserved.

####----------------------------------------------------------------------------------
#Description : Terraform module to create consistent naming for multiple names.
####----------------------------------------------------------------------------------

module "label" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  enabled     = var.efs_enabled
}

####----------------------------------------------------------------------------------
#Description :Provides an Elastic File System (EFS) File System resource.
####----------------------------------------------------------------------------------
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

####----------------------------------------------------------------------------------
#Description : Provides an Elastic File System (EFS) mount target.
####----------------------------------------------------------------------------------
resource "aws_efs_mount_target" "default" {
  count           = var.efs_enabled && length(var.availability_zones) > 0 ? length(var.availability_zones) : 0
  file_system_id  = join("", aws_efs_file_system.default[*].id)
  ip_address      = var.mount_target_ip_address
  subnet_id       = var.subnets[count.index]
  security_groups = [join("", aws_security_group.default[*].id)]
}

####----------------------------------------------------------------------------------
#Description : Provides a security group resource.
####----------------------------------------------------------------------------------
#tfsec:ignore:aws-ec2-add-description-to-security-group-rule
resource "aws_security_group" "default" {
  count       = var.efs_enabled ? 1 : 0
  name        = module.label.id
  description = var.mount_target_description
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

  ingress {
    from_port   = "2049" # NFS
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = var.allow_cidr #tfsec:ignore:aws-vpc-no-public-egress-sgr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "for all"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
  }

  tags = module.label.tags
}

####----------------------------------------------------------------------------------
#Description : Provides a security group resource.
####----------------------------------------------------------------------------------
resource "aws_efs_backup_policy" "policy" {
  count = var.efs_enabled && var.efs_backup_policy_enabled == "ENABLED" ? 1 : 0

  file_system_id = join("", aws_efs_file_system.default[*].id)

  backup_policy {
    status = var.efs_backup_policy_enabled ? "ENABLED" : "DISABLED"
  }
}

####----------------------------------------------------------------------------------
#Description : Provides an Elastic File System (EFS) access point.
####----------------------------------------------------------------------------------
resource "aws_efs_access_point" "default" {
  count          = var.efs_enabled && var.access_point_enabled ? 1 : 0
  file_system_id = join("", aws_efs_file_system.default[*].id)

  tags = module.label.tags
}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

################################################################################
# Replication Configuration
################################################################################

resource "aws_efs_replication_configuration" "this" {
  count = var.efs_enabled && var.replication_enabled ? 1 : 0

  source_file_system_id = aws_efs_file_system.default[0].id

  dynamic "destination" {
    for_each = [var.replication_configuration_destination]

    content {
      availability_zone_name = try(destination.value.availability_zones, null)
      kms_key_id             = try(destination.value.kms_key_id, null)
      region                 = try(destination.value.region, null)
    }
  }
}

resource "aws_efs_file_system_policy" "this" {
  count = var.efs_enabled ? 1 : 0

  file_system_id                     = aws_efs_file_system.default[0].id
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  policy                             = data.aws_iam_policy_document.policy[0].json
}

data "aws_iam_policy_document" "policy" {
  count = var.efs_enabled ? 1 : 0

  source_policy_documents   = var.source_policy_documents
  override_policy_documents = var.override_policy_documents

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, [aws_efs_file_system.default[0].arn], null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, statement.value.condition, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }

  dynamic "statement" {
    for_each = var.deny_nonsecure_transport ? [1] : []

    content {
      sid       = "NonSecureTransport"
      effect    = "Deny"
      actions   = ["*"]
      resources = [aws_efs_file_system.default[0].arn]

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }
}