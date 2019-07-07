module "label" {
  source      = "git::https://github.com/clouddrove/terraform-labels"
  name        = "label"
  application = "clouddrove"
  environment = "test"
  label_order = ["name", "application", "environment"]
}

resource "aws_efs_file_system" "default" {
  count                           = var.efs_enabled ? 1 : 0
  tags                            = module.label.tags
  encrypted                       = var.encrypted
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
}

resource "aws_efs_mount_target" "default" {
  count           = var.efs_enabled && length(var.availability_zones) > 0 ? length(var.availability_zones) : 0
  file_system_id  = join("", aws_efs_file_system.default.*.id)
  ip_address      = var.mount_target_ip_address
  subnet_id       = var.subnets[count.index]
  security_groups = [join("", aws_security_group.default.*.id)]
}

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
