output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC ID."
}

output "public_subnet_cidrs" {
  value       = module.subnets.public_subnet_cidrs
  description = "The CIDR of the subnet."
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "The CIDR of the subnet."
}

output "vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "The CIDR of the vpc."
}

output "efs_arn" {
  value       = module.efs.arn
  description = "EFS ARN"
}

output "efs_id" {
  value       = module.efs.id
  description = "EFS ID"
}

output "efs_mount_target_ids" {
  value       = module.efs.mount_target_ids
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "efs_mount_target_ips" {
  sensitive   = true
  value       = module.efs.mount_target_ips
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "efs_network_interface_ids" {
  value       = module.efs.network_interface_ids
  description = "List of mount target network interface IDs"
}

output "tags" {
  value       = module.efs.tags
  description = "The tags of the ecs cluster"

}