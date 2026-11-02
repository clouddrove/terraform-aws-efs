## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access_point_enabled | Enable or disable the creation of an EFS access point. | `bool` | `true` | no |
| allow_cidr | List of CIDR blocks allowed to access EFS over NFS (TCP/2049). Each CIDR block is managed as a separate ingress rule. | `list(any)` | `[]` | no |
| availability_zones | List of Availability Zone IDs used to create EFS mount targets. | `list(string)` | n/a | yes |
| bypass_policy_lockout_safety_check | A flag to indicate whether to bypass the `aws_efs_file_system_policy` lockout safety check. Defaults to `false`. | `bool` | `false` | no |
| creation_token | A unique name (a maximum of 64 characters are allowed) used as a reference when creating the EFS file system. | `string` | n/a | yes |
| deny_nonsecure_transport | Determines whether `aws:SecureTransport` is required when connecting to the EFS file system. | `bool` | `false` | no |
| efs_backup_policy_enabled | Enable automatic backups for the EFS file system. | `bool` | `true` | no |
| efs_enabled | Set to `false` to prevent the module from creating EFS resources. | `bool` | `true` | no |
| egress_cidr_blocks | List of IPv4 CIDR blocks allowed for outbound traffic from the EFS security group. Each CIDR block is managed as a separate egress rule. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| egress_from_port | Starting port for the outbound security group rule. Not applicable when the protocol is `-1` (all traffic). | `number` | `0` | no |
| egress_protocol | IP protocol for the outbound security group rule. Use `-1` for all protocols. | `number` | `-1` | no |
| egress_to_port | Ending port for the outbound security group rule. Not applicable when the protocol is `-1` (all traffic). | `number` | `0` | no |
| enable_aws_efs_file_system_policy | Enable or disable the EFS file system policy. Defaults to `false`. | `bool` | `false` | no |
| encrypted | If `true`, the EFS file system will be encrypted at rest. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `"test"` | no |
| from_port | Starting port for the NFS ingress security group rule. Defaults to TCP port `2049`. | `number` | `2049` | no |
| kms_key_id | ARN of the KMS key used for EFS encryption. When specifying `kms_key_id`, `encrypted` must be set to `true`. | `string` | `""` | no |
| label_order | Label order, e.g. `name`, `environment`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| managedby | ManagedBy tag value, e.g. `CloudDrove`. | `string` | `"hello@clouddrove.com"` | no |
| mount_target_description | Description associated with the EFS mount target security group. | `string` | `"this is mount target security group "` | no |
| mount_target_ip_address | IP address within the specified subnet range to assign to the EFS mount target. | `string` | `null` | no |
| name | Solution name, e.g. `app`. | `string` | `""` | no |
| override_policy_documents | List of IAM policy documents that are merged together into the exported document. Statements with non-blank `sid` values override statements with matching `sid` values. | `list(string)` | `[]` | no |
| performance_mode | EFS file system performance mode. Valid values are `generalPurpose` or `maxIO`. | `string` | `"generalPurpose"` | no |
| policy_statements | List of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permissions. | `any` | `[]` | no |
| protocol | IP protocol for the NFS ingress security group rule. Defaults to `tcp`. | `string` | `"tcp"` | no |
| provisioned_throughput_in_mibps | Provisioned throughput in MiB/s. Only applicable when `throughput_mode` is set to `provisioned`. | `string` | `0` | no |
| replication_configuration_destination | Destination configuration for EFS replication. Supports destination region, KMS key ID, or a single Availability Zone name for One Zone destinations. | `any` | `{}` | no |
| replication_enabled | Set to `false` to disable EFS replication configuration. | `bool` | `true` | no |
| security_groups | List of existing security group IDs allowed to access EFS over NFS (TCP/2049). Each security group ID is managed as a separate ingress rule. | `list(string)` | n/a | yes |
| source_policy_documents | List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid` values. | `list(string)` | `[]` | no |
| subnets | List of subnet IDs in which EFS mount targets will be created. | `list(string)` | n/a | yes |
| throughput_mode | Throughput mode for the EFS file system. Valid values are `bursting` and `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`. | `string` | `"bursting"` | no |
| to_port | Ending port for the NFS ingress security group rule. Defaults to TCP port `2049`. | `number` | `2049` | no |
| vpc_id | ID of the VPC in which the EFS security group will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the EFS file system. |
| id | ID of the EFS file system. |
| mount_target_ids | List of EFS mount target IDs (one per Availability Zone). |
| mount_target_ips | List of EFS mount target IP addresses (one per Availability Zone). |
| network_interface_ids | List of network interface IDs associated with EFS mount targets. |
| tags | Tags associated with the EFS file system. |