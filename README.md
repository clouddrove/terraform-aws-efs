<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>




<h1 align="center">
    Terraform AWS EFS
</h1>

<p align="center" style="font-size: 1.2rem;">
    Terraform module to create or deploy EFS on AWS.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v0.14-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="Licence">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-efs'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+EFS&url=https://github.com/clouddrove/terraform-aws-efs'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+EFS&url=https://github.com/clouddrove/terraform-aws-efs'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure.

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies:

- [Terraform 0.12](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-efs/releases).


### Simple Example
Here is an example of how you can use this module in your inventory structure:
```hcl
    module "efs" {
      source             = "git::https://github.com/clouddrove/terraform-aws-efs.git?ref=tags/0.12.0"
      name               = "efs"
      application        = var.application
      environment        = var.environment
      label_order        = var.label_order
      creation_token     = var.token
      region             = var.region
      availability_zones = ["${var.region}b", "${var.region}c"]
      vpc_id             = module.vpc.vpc_id
      subnets            = module.subnets.private_subnet_id
      security_groups    = ["sg-xxxxxxxxxxxx"]
    }
```






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application | Application name, e.g. `cd` or `CloudDrove` | string | n/a | yes |
| attributes | Additional attributes \(e.g. `1`\) | list(string) | `<list>` | no |
| availability\_zones | Availability Zone IDs | list(string) | n/a | yes |
| creation\_token | A unique name \(a maximum of 64 characters are allowed\) used as reference when creating the EFS | string | n/a | yes |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `"-"` | no |
| efs\_enabled | Set to false to prevent the module from creating any resources | bool | `"true"` | no |
| encrypted | If true, the file system will be encrypted | bool | `"false"` | no |
| environment | Environment, e.g. `prod`, `staging`, `dev`, or `test` | string | n/a | yes |
| label\_order | label order, e.g. `name`,`application` | list | `<list>` | no |
| managedby | ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'. | string | `"anmol@clouddrove.com"` | no |
| mount\_target\_ip\_address | The address \(within the address range of the specified subnet\) at which the file system may be mounted via the mount target | string | `""` | no |
| name | Solution name, e.g. `app` | string | n/a | yes |
| performance\_mode | The file system performance mode. Can be either `generalPurpose` or `maxIO` | string | `"generalPurpose"` | no |
| provisioned\_throughput\_in\_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput\_mode` set to provisioned | string | `"0"` | no |
| region | AWS Region | string | n/a | yes |
| security\_groups | Security group IDs to allow access to the EFS | list(string) | n/a | yes |
| subnets | Subnet IDs | list(string) | n/a | yes |
| tags | Additional tags \(e.g. `\{ BusinessUnit = "XYZ" \}` | map(string) | `<map>` | no |
| throughput\_mode | Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned\_throughput\_in\_mibps` | string | `"bursting"` | no |
| vpc\_id | VPC ID | string | n/a | yes |
| zone\_id | Route53 DNS zone ID | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| id | EFS ID |
| mount\_target\_ids | List of EFS mount target IDs \(one per Availability Zone\) |
| mount\_target\_ips | List of EFS mount target IPs \(one per Availability Zone\) |
| network\_interface\_ids | List of mount target network interface IDs |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system.

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-efs/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-efs)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
