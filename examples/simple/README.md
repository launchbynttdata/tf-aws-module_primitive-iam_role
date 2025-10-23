# simple

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_iam_role"></a> [aws\_iam\_role](#module\_aws\_iam\_role) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the IAM role. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the IAM role. | `map(string)` | `{}` | no |
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | IAM assume role policy statements to include in the trust policy. | <pre>list(object({<br/>    sid     = optional(string)<br/>    effect  = optional(string, "Allow")<br/>    actions = list(string)<br/><br/>    # each statement may have multiple principal blocks<br/>    principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })))<br/><br/>    conditions = optional(list(object({<br/>      test     = string       # e.g., "StringEquals"<br/>      variable = string       # e.g., "aws:PrincipalTag/Team"<br/>      values   = list(string) # e.g., ["DevOps"]<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | The maximum session duration (in seconds) for the IAM role. | `number` | `3600` | no |
| <a name="input_permission_boundary_arn"></a> [permission\_boundary\_arn](#input\_permission\_boundary\_arn) | The ARN of the policy used to set the permissions boundary for the IAM role. | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | The path for the IAM role. | `string` | `null` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Whether to force detachment of policies when deleting the IAM role. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the IAM role. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role. |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role. |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The ID of the IAM role. |
| <a name="output_role_unique_id"></a> [role\_unique\_id](#output\_role\_unique\_id) | The unique ID of the IAM role. |
| <a name="output_role_tags"></a> [role\_tags](#output\_role\_tags) | The tags applied to the IAM role. |
<!-- END_TF_DOCS -->
