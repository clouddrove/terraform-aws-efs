## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_point\_enabled | n/a | `bool` | `true` | no |
| allow\_cidr | Provide allowed cidr to efs | `list(any)` | `[]` | no |
| availability\_zones | Availability Zone IDs | `list(string)` | n/a | yes |
| bypass\_policy\_lockout\_safety\_check | A flag to indicate whether to bypass the `aws_efs_file_system_policy` lockout safety check. Defaults to `false` | `bool` | `false` | no |
| creation\_token | A unique name (a maximum of 64 characters are allowed) used as reference when creating the EFS | `string` | n/a | yes |
| deny\_nonsecure\_transport | Determines whether `aws:SecureTransport` is required when connecting to elastic file system | `bool` | `false` | no |
| efs\_backup\_policy\_enabled | If `true`, it will turn on automatic backups. | `bool` | `true` | no |
| efs\_enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| egress\_cidr\_blocks | Security group IDs to allow access to the EFS | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| egress\_from\_port | Security group IDs to allow access to the EFS | `number` | `0` | no |
| egress\_protocol | Security group IDs to allow access to the EFS | `number` | `-1` | no |
| egress\_to\_port | Security group IDs to allow access to the EFS | `number` | `0` | no |
| enable\_aws\_efs\_file\_system\_policy | A flag to enable or disable aws efs file system policy . Defaults to `false` | `bool` | `false` | no |
| encrypted | If true, the file system will be encrypted | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `"test"` | no |
| from\_port | Security group IDs to allow access to the EFS | `number` | `2049` | no |
| kms\_key\_id | The ARN for the KMS encryption key. When specifying kms\_key\_id, encrypted needs to be set to true. | `string` | `""` | no |
| label\_order | label order, e.g. `name`,`application` | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| mount\_target\_description | n/a | `string` | `"this is mount target security group "` | no |
| mount\_target\_ip\_address | The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target | `string` | `null` | no |
| name | Solution name, e.g. `app` | `string` | `""` | no |
| override\_policy\_documents | List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid` | `list(string)` | `[]` | no |
| performance\_mode | The file system performance mode. Can be either `generalPurpose` or `maxIO` | `string` | `"generalPurpose"` | no |
| policy\_statements | A list of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage | `any` | `[]` | no |
| protocol | Security group IDs to allow access to the EFS | `string` | `"tcp"` | no |
| provisioned\_throughput\_in\_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned | `string` | `0` | no |
| replication\_configuration\_destination | A destination configuration block | `any` | `{}` | no |
| replication\_enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| security\_groups | Security group IDs to allow access to the EFS | `list(string)` | n/a | yes |
| source\_policy\_documents | List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s | `list(string)` | `[]` | no |
| subnets | Subnet IDs | `list(string)` | n/a | yes |
| throughput\_mode | Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps` | `string` | `"bursting"` | no |
| to\_port | Security group IDs to allow access to the EFS | `number` | `2049` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| id | EFS ID |
| mount\_target\_ids | List of EFS mount target IDs (one per Availability Zone) |
| mount\_target\_ips | List of EFS mount target IPs (one per Availability Zone) |
| network\_interface\_ids | List of mount target network interface IDs |
| tags | The tags of the ecs cluster |

