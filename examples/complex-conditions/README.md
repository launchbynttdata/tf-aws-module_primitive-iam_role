# Complex Conditions IAM Role Example

This example demonstrates the most advanced features of IAM role assume role policies with complex conditions and multiple statement types.

## Features Demonstrated

- **Multiple assume role statements**: Cross-account, OIDC, and service principals
- **Complex conditions**: Time, IP, MFA, tag, and encryption-based
- **Permission boundaries**: Optional additional security layer
- **Advanced policy conditions**: Resource-level access control
- **Multiple principal types**: AWS accounts, federated identities, and services

## Security Features

### Cross-Account Access
- Multi-factor authentication required
- External ID for confused deputy protection
- Time-based access windows
- IP address restrictions
- Principal tag validation
- Secure transport enforcement

### OIDC Federation
- GitHub Actions integration example
- Repository-based access control
- Subject pattern matching
- Audience verification

### Service Principals
- Source account validation
- Source ARN pattern matching
- Service-specific conditions

## Usage

```bash
# Minimal setup
terraform apply \
  -var="project_name=my-project" \
  -var="external_id=my-secure-external-id"

# Full security setup
terraform apply \
  -var="project_name=secure-project" \
  -var="environment=prod" \
  -var="external_id=ultra-secure-external-id-123" \
  -var="trusted_account_arns=[\"arn:aws:iam::123456789012:root\"]" \
  -var="max_session_duration=7200" \
  -var="permission_boundary_arn=arn:aws:iam::123456789012:policy/DeveloperBoundary"

# With OIDC integration
terraform apply \
  -var="oidc_provider_arns=[\"arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com\"]" \
  -var="trusted_repositories=[\"myorg/myrepo\"]" \
  -var="allowed_oidc_subjects=[\"repo:myorg/myrepo:ref:refs/heads/main\"]"
```

## Policy Conditions Demonstrated

1. **Time-based access**: DateGreaterThan/DateLessThan
2. **Network restrictions**: IpAddress conditions
3. **MFA requirements**: Bool and NumericLessThan
4. **Tag validation**: StringEquals on principal tags
5. **Encryption requirements**: Server-side encryption conditions
6. **Regional restrictions**: RequestedRegion validation
7. **Source validation**: SourceAccount and SourceArn

## Testing

This example tests all advanced features:

- Multiple statement blocks in assume role policy
- Complex condition combinations
- Permission boundary integration
- Tag-based resource access
- Time and network-based restrictions
- OIDC web identity federation
- Service principal with conditions
- Advanced policy condition types

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
| <a name="module_complex_role"></a> [complex\_role](#module\_complex\_role) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.cloudwatch_logs_conditional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.time_based_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, staging, prod) | `string` | `"dev"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds | `number` | `3600` | no |
| <a name="input_permission_boundary_arn"></a> [permission\_boundary\_arn](#input\_permission\_boundary\_arn) | ARN of the permissions boundary policy | `string` | `null` | no |
| <a name="input_trusted_account_arns"></a> [trusted\_account\_arns](#input\_trusted\_account\_arns) | List of trusted AWS account ARNs | `list(string)` | `[]` | no |
| <a name="input_max_mfa_age_seconds"></a> [max\_mfa\_age\_seconds](#input\_max\_mfa\_age\_seconds) | Maximum age of MFA token in seconds | `number` | `3600` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External ID for cross-account access | `string` | n/a | yes |
| <a name="input_allowed_departments"></a> [allowed\_departments](#input\_allowed\_departments) | List of allowed department values in principal tags | `list(string)` | <pre>[<br/>  "Engineering",<br/>  "DevOps",<br/>  "Security"<br/>]</pre> | no |
| <a name="input_access_start_time"></a> [access\_start\_time](#input\_access\_start\_time) | Start time for access window (ISO 8601 format) | `string` | `"2024-01-01T00:00:00Z"` | no |
| <a name="input_access_end_time"></a> [access\_end\_time](#input\_access\_end\_time) | End time for access window (ISO 8601 format) | `string` | `"2026-12-31T23:59:59Z"` | no |
| <a name="input_allowed_ip_ranges"></a> [allowed\_ip\_ranges](#input\_allowed\_ip\_ranges) | List of allowed IP ranges in CIDR notation | `list(string)` | <pre>[<br/>  "10.0.0.0/8",<br/>  "172.16.0.0/12",<br/>  "192.168.0.0/16"<br/>]</pre> | no |
| <a name="input_oidc_provider_arns"></a> [oidc\_provider\_arns](#input\_oidc\_provider\_arns) | List of OIDC provider ARNs for web identity federation | `list(string)` | `[]` | no |
| <a name="input_oidc_provider_url"></a> [oidc\_provider\_url](#input\_oidc\_provider\_url) | OIDC provider URL (without https://) | `string` | `"token.actions.githubusercontent.com"` | no |
| <a name="input_allowed_oidc_subjects"></a> [allowed\_oidc\_subjects](#input\_allowed\_oidc\_subjects) | List of allowed OIDC subject patterns | `list(string)` | <pre>[<br/>  "repo:myorg/*:ref:refs/heads/main"<br/>]</pre> | no |
| <a name="input_trusted_repositories"></a> [trusted\_repositories](#input\_trusted\_repositories) | List of trusted repository names for OIDC | `list(string)` | `[]` | no |
| <a name="input_trusted_services"></a> [trusted\_services](#input\_trusted\_services) | List of trusted AWS service principals | `list(string)` | <pre>[<br/>  "lambda.amazonaws.com",<br/>  "ec2.amazonaws.com"<br/>]</pre> | no |
| <a name="input_enable_service_source_condition"></a> [enable\_service\_source\_condition](#input\_enable\_service\_source\_condition) | Whether to enable source account/ARN conditions for service principals | `bool` | `true` | no |
| <a name="input_source_account_id"></a> [source\_account\_id](#input\_source\_account\_id) | Source account ID for service principal conditions | `string` | `null` | no |
| <a name="input_allowed_source_arns"></a> [allowed\_source\_arns](#input\_allowed\_source\_arns) | List of allowed source ARN patterns | `list(string)` | `[]` | no |
| <a name="input_allowed_regions"></a> [allowed\_regions](#input\_allowed\_regions) | List of allowed AWS regions | `list(string)` | <pre>[<br/>  "us-east-1",<br/>  "us-west-2"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_complex_role_arn"></a> [complex\_role\_arn](#output\_complex\_role\_arn) | ARN of the complex IAM role |
| <a name="output_complex_role_name"></a> [complex\_role\_name](#output\_complex\_role\_name) | Name of the complex IAM role |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role (standard output for test framework) |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the IAM role (standard output for test framework) |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | ID of the IAM role (standard output for test framework) |
| <a name="output_role_tags"></a> [role\_tags](#output\_role\_tags) | Tags of the IAM role (standard output for test framework) |
| <a name="output_role_assume_policy_summary"></a> [role\_assume\_policy\_summary](#output\_role\_assume\_policy\_summary) | Summary of the assume role policy features |
| <a name="output_permission_boundary_info"></a> [permission\_boundary\_info](#output\_permission\_boundary\_info) | Information about the permission boundary |
| <a name="output_security_features"></a> [security\_features](#output\_security\_features) | List of security features enabled |
<!-- END_TF_DOCS -->
