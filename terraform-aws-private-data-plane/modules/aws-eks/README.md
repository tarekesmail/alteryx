<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.46.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 18.30.2 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_iam_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.node_groups_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.workers_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.eks_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.allow_access_from_another_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.logging_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_eks_cluster_auth.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_roles.sso_administrator_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_roles) | data source |
| [aws_subnets.control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | n/a | yes |
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | n/a | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_color"></a> [color](#input\_color) | n/a | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Determines whether to run EKS module | `bool` | `true` | no |
<<<<<<< HEAD
| <a name="input_eks_config"></a> [eks\_config](#input\_eks\_config) | n/a | `any` | <pre>{<br>  "cluster_additional_security_group_ids": [],<br>  "cluster_addons": {<br>    "coredns": {<br>      "addon_version": "v1.8.7-eksbuild.3",<br>      "resolve_conflicts": "OVERWRITE"<br>    },<br>    "kube-proxy": {<br>      "addon_version": "v1.22.11-eksbuild.2",<br>      "resolve_conflicts": "OVERWRITE"<br>    },<br>    "vpc-cni": {<br>      "addon_version": "v1.12.0-eksbuild.1",<br>      "resolve_conflicts": "OVERWRITE"<br>    }<br>  }<br>}</pre> | no |
=======
| <a name="input_eks_config"></a> [eks\_config](#input\_eks\_config) | n/a | `any` | <pre>{<br>  "cluster_addons": {<br>    "coredns": {<br>      "addon_version": "v1.8.7-eksbuild.3",<br>      "resolve_conflicts": "OVERWRITE"<br>    },<br>    "kube-proxy": {<br>      "addon_version": "v1.22.11-eksbuild.2",<br>      "resolve_conflicts": "OVERWRITE"<br>    },<br>    "vpc-cni": {<br>      "addon_version": "v1.12.0-eksbuild.1",<br>      "resolve_conflicts": "OVERWRITE"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_eks_control_subnet_tags"></a> [eks\_control\_subnet\_tags](#input\_eks\_control\_subnet\_tags) | n/a | `list(string)` | `[]` | no |
>>>>>>> 18db0a0 (optional tags)
| <a name="input_eks_managed_node_group_defaults"></a> [eks\_managed\_node\_group\_defaults](#input\_eks\_managed\_node\_group\_defaults) | n/a | `any` | <pre>{<br>  "ami_release_version": "1.22.15-20221112",<br>  "ami_type": "AL2_x86_64",<br>  "capacity_type": "ON_DEMAND",<br>  "create_launch_template": false,<br>  "disk_size": 100,<br>  "launch_template_name": "",<br>  "taints": []<br>}</pre> | no |
| <a name="input_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#input\_eks\_managed\_node\_groups) | n/a | `any` | <pre>{<br>  "default": {<br>    "ami_release_version": "1.22.15-20221112",<br>    "ami_type": "AL2_x86_64",<br>    "capacity_type": "ON_DEMAND",<br>    "create_launch_template": false,<br>    "desired_size": 1,<br>    "disk_size": 20,<br>    "instance_types": [<br>      "t3a.medium"<br>    ],<br>    "labels": {<br>      "type": "default"<br>    },<br>    "launch_template_name": "",<br>    "max_size": 3,<br>    "min_size": 1,<br>    "name": "default",<br>    "taints": []<br>  }<br>}</pre> | no |
| <a name="input_eks_node_subnet_tags"></a> [eks\_node\_subnet\_tags](#input\_eks\_node\_subnet\_tags) | n/a | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | `""` | no |

## Outputs

| Name                                                                                                                                             | Description |
|--------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| <a name="output_CONTEXT"></a> [CONTEXT](#output\_CONTEXT)                                                                                        | n/a |
| <a name="output_cluster_access_token"></a> [cluster\_access\_token](#output\_cluster\_access\_token)                                             | n/a |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint)                                                           | n/a |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id)                                                                             | n/a |
| <a name="output_oicd_issuer"></a> [oicd\_issuer](#output\_oicd\_issuer)                                                                          | TODO keep this one since in data\_plane module is incorrect naming |
| <a name="output_oidc_issuer"></a> [oidc\_issuer](#output\_oidc\_issuer)                                                                          | n/a |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn)                                                      | n/a |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id)                                     | n/a |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id)                            | n/a |
<!-- END_TF_DOCS -->