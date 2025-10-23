# Cross-Account IAM Role Example

This example demonstrates creating an IAM role for cross-account access with advanced security features:

## Features Demonstrated

- **Cross-account trust relationship**: Allows another AWS account to assume this role
- **MFA requirement**: Requires multi-factor authentication
- **External ID**: Additional security layer for cross-account access
- **Session duration**: Extended session duration for long-running tasks
- **Conditional access**: Time-based and authentication-based conditions
- **Custom path**: Role organized under a specific path
- **Policy attachment**: Example of attaching permissions to the role

## Security Features

1. **Multi-Factor Authentication (MFA)**: Users must authenticate with MFA
2. **External ID**: Prevents confused deputy attacks
3. **Time-based conditions**: MFA token must be recent (< 1 hour)
4. **Least privilege**: Only read-only permissions granted

## Usage

```bash
# Set required variables
export TF_VAR_trusted_account_id="123456789012"
export TF_VAR_external_id="my-secure-external-id-12345"

# Initialize and apply
terraform init
terraform plan
terraform apply
```

## Assuming the Role

After deployment, the role can be assumed using:

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::ACCOUNT:role/cross-account/cross-account-access-role \
  --role-session-name cross-account-session \
  --external-id my-secure-external-id-12345 \
  --serial-number arn:aws:iam::TRUSTED-ACCOUNT:mfa/username \
  --token-code 123456
```

## Testing

This example tests:
- Cross-account principal configuration
- Multiple condition blocks
- Custom paths
- Extended session duration
- Policy attachment to roles

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cross_account_role"></a> [cross\_account\_role](#module\_cross\_account\_role) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.cross_account_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the cross-account IAM role | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the IAM role | `string` | `"Cross-account access role with MFA and external ID requirements"` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds | `number` | `14400` | no |
| <a name="input_path"></a> [path](#input\_path) | Path for the IAM role | `string` | `"/cross-account/"` | no |
| <a name="input_statement_sid"></a> [statement\_sid](#input\_statement\_sid) | SID for the assume role policy statement | `string` | `"CrossAccountAssumeRole"` | no |
| <a name="input_trusted_account_arns"></a> [trusted\_account\_arns](#input\_trusted\_account\_arns) | List of trusted AWS account ARNs that can assume this role | `list(string)` | n/a | yes |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External ID for additional security when assuming the role | `string` | n/a | yes |
| <a name="input_max_mfa_age_seconds"></a> [max\_mfa\_age\_seconds](#input\_max\_mfa\_age\_seconds) | Maximum age of MFA token in seconds | `number` | `3600` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the IAM role | `map(string)` | `{}` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name for the attached policy | `string` | `"cross-account-permissions"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cross_account_role_arn"></a> [cross\_account\_role\_arn](#output\_cross\_account\_role\_arn) | The ARN of the cross-account IAM role |
| <a name="output_cross_account_role_name"></a> [cross\_account\_role\_name](#output\_cross\_account\_role\_name) | The name of the cross-account IAM role |
| <a name="output_cross_account_role_unique_id"></a> [cross\_account\_role\_unique\_id](#output\_cross\_account\_role\_unique\_id) | The unique ID of the cross-account IAM role |
| <a name="output_role_assume_command"></a> [role\_assume\_command](#output\_role\_assume\_command) | Example AWS CLI command to assume this role |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The unique ID of the IAM role |
| <a name="output_role_tags"></a> [role\_tags](#output\_role\_tags) | The tags assigned to the IAM role |
<!-- END_TF_DOCS -->
