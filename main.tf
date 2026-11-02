# Managed By : CloudDrove
# Description : This Script is used to create Elastic File System (EFS).
# Copyright @ CloudDrove. All Right Reserved.

##------------------------------------------------------------------------------
## Description : Terraform module to create consistent naming for multiple names.
##------------------------------------------------------------------------------

module "label" {
  source  = "clouddrove/labels/aws"
  version = "1.3.1"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  enabled     = var.efs_enabled
}

##------------------------------------------------------------------------------
## Description : Provides an Elastic File System (EFS) File System resource.
##------------------------------------------------------------------------------

resource "aws_efs_file_system" "default" {
  count = var.efs_enabled ? 1 : 0

  creation_token                  = var.creation_token
  encrypted                       = var.encrypted
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
  kms_key_id                      = var.kms_key_id

  tags = module.label.tags
}

##------------------------------------------------------------------------------
## Description : Provides an Elastic File System (EFS) mount target.
##------------------------------------------------------------------------------

resource "aws_efs_mount_target" "default" {
  count = var.efs_enabled ? length(nonsensitive(var.availability_zones)) : 0

  file_system_id  = aws_efs_file_system.default[0].id
  ip_address      = var.mount_target_ip_address
  subnet_id       = var.subnets[count.index]
  security_groups = [aws_security_group.default[0].id]
}

##------------------------------------------------------------------------------
## Description : Provides a security group resource.
##------------------------------------------------------------------------------

resource "aws_security_group" "default" {
  count = var.efs_enabled ? 1 : 0

  name        = module.label.id
  description = var.mount_target_description
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = module.label.tags
}

##------------------------------------------------------------------------------
## Description : Allow NFS ingress from trusted security groups.
##------------------------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "nfs_security_group" {
  for_each = var.efs_enabled ? {
    for index, sg_id in nonsensitive(var.security_groups) :
    tostring(index) => sg_id
  } : {}

  security_group_id            = aws_security_group.default[0].id
  referenced_security_group_id = each.value

  from_port   = var.from_port
  to_port     = var.to_port
  ip_protocol = var.protocol

  description = "Allow NFS from trusted security group"
}

##------------------------------------------------------------------------------
## Description : Allow NFS ingress from approved CIDR ranges.
##------------------------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "nfs_cidr" {
  for_each = var.efs_enabled ? toset(var.allow_cidr) : toset([])

  security_group_id = aws_security_group.default[0].id
  cidr_ipv4         = each.value

  from_port   = var.from_port
  to_port     = var.to_port
  ip_protocol = var.protocol

  description = "Allow NFS from approved CIDR"
}

##------------------------------------------------------------------------------
## Description : Configure security group egress rules.
##------------------------------------------------------------------------------

#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_vpc_security_group_egress_rule" "default" {
  for_each = var.efs_enabled ? toset(var.egress_cidr_blocks) : toset([])

  security_group_id = aws_security_group.default[0].id
  cidr_ipv4         = each.value

  ip_protocol = tostring(var.egress_protocol)

  # AWS requires ports to be omitted when all protocols are allowed.
  from_port = tostring(var.egress_protocol) == "-1" ? null : var.egress_from_port
  to_port   = tostring(var.egress_protocol) == "-1" ? null : var.egress_to_port

  description = "Allow configured outbound traffic"
}

##------------------------------------------------------------------------------
## Description : Provides an EFS backup policy resource.
##------------------------------------------------------------------------------

resource "aws_efs_backup_policy" "policy" {
  count = var.efs_enabled && var.efs_backup_policy_enabled ? 1 : 0

  file_system_id = aws_efs_file_system.default[0].id

  backup_policy {
    status = "ENABLED"
  }
}

##------------------------------------------------------------------------------
## Description : Provides an Elastic File System (EFS) access point.
##------------------------------------------------------------------------------

resource "aws_efs_access_point" "default" {
  count = var.efs_enabled && var.access_point_enabled ? 1 : 0

  file_system_id = aws_efs_file_system.default[0].id

  tags = module.label.tags
}

##------------------------------------------------------------------------------
## Replication Configuration
##------------------------------------------------------------------------------

resource "aws_efs_replication_configuration" "this" {
  count = (
    var.efs_enabled &&
    var.replication_enabled &&
    try(length(var.replication_configuration_destination), 0) > 0
  ) ? 1 : 0

  source_file_system_id = aws_efs_file_system.default[0].id

  dynamic "destination" {
    for_each = [var.replication_configuration_destination]

    content {
      availability_zone_name = try(
        destination.value.availability_zone_name,
        null
      )

      kms_key_id = try(destination.value.kms_key_id, null)
      region     = try(destination.value.region, null)
    }
  }
}

##------------------------------------------------------------------------------
## EFS File System Policy
##------------------------------------------------------------------------------

resource "aws_efs_file_system_policy" "this" {
  count = (
    var.efs_enabled &&
    var.enable_aws_efs_file_system_policy
  ) ? 1 : 0

  file_system_id                     = aws_efs_file_system.default[0].id
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  policy                             = data.aws_iam_policy_document.policy[0].json
}

##------------------------------------------------------------------------------
## Description : Provides an IAM policy document for EFS.
##------------------------------------------------------------------------------

data "aws_iam_policy_document" "policy" {
  count = (
    var.efs_enabled &&
    var.enable_aws_efs_file_system_policy
  ) ? 1 : 0

  source_policy_documents   = var.source_policy_documents
  override_policy_documents = var.override_policy_documents

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid         = try(statement.value.sid, null)
      actions     = try(statement.value.actions, null)
      not_actions = try(statement.value.not_actions, null)
      effect      = try(statement.value.effect, null)

      resources = try(
        statement.value.resources,
        [aws_efs_file_system.default[0].arn]
      )

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
        for_each = try(
          statement.value.conditions,
          statement.value.condition,
          []
        )

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }

  ##---------------------------------------------------------------------------
  ## Deny non-secure transport
  ##---------------------------------------------------------------------------

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
