# EC2 Instance Profile Example

This example demonstrates creating an IAM role and instance profile for EC2 instances with comprehensive AWS service access.

## Features Demonstrated

- **Instance profile creation**: EC2-compatible role attachment
- **Systems Manager access**: SSM agent permissions
- **CloudWatch monitoring**: Logs and metrics collection
- **Conditional policies**: Application-specific parameter access
- **Source IP restrictions**: Network-based security (optional)
- **User data integration**: Automated instance configuration

## Capabilities Tested

1. **AWS Systems Manager**: Remote access and patch management
2. **CloudWatch Agent**: Metrics and log collection
3. **Parameter Store**: Application configuration
4. **Secrets Manager**: Secure credential storage
5. **S3 access**: Data storage and retrieval (optional)
6. **Custom policies**: User-defined permissions

## Usage

```bash
# Basic EC2 role with SSM
terraform apply \
  -var="instance_role_name=web-server-role" \
  -var="application_name=my-web-app"

# With example EC2 instance
terraform apply \
  -var="create_example_instance=true" \
  -var="ami_id=ami-0c02fb55956c7d316" \
  -var="subnet_id=subnet-12345" \
  -var="security_group_ids=[\"sg-12345\"]"

# With application-specific access
terraform apply \
  -var="application_name=my-app" \
  -var="enable_parameter_store_access=true" \
  -var="enable_secrets_manager_access=true"

# With IP restrictions
terraform apply \
  -var="enable_source_ip_condition=true" \
  -var="allowed_source_ips=[\"10.0.0.0/8\", \"192.168.1.0/24\"]"
```

## Security Features

- **Path-based organization**: Role organized under `/ec2/`
- **Force detach policies**: Safe role deletion
- **Custom permissions**: Application-scoped access
- **Conditional access**: IP and tag-based restrictions

## Testing

This example tests:

- EC2 service principal assumption
- Instance profile creation and attachment
- Multiple AWS managed policy attachments
- Custom policy generation with conditions
- User data script generation
- Extended session duration (4 hours)

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
| <a name="module_ec2_instance_role"></a> [ec2\_instance\_role](#module\_ec2\_instance\_role) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role_policy.application_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_managed_instance_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_role_name"></a> [instance\_role\_name](#input\_instance\_role\_name) | Name for the EC2 instance role | `string` | `"ec2-instance-role"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, staging, prod) | `string` | `"dev"` | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the application this instance will run | `string` | `null` | no |
| <a name="input_enable_source_ip_condition"></a> [enable\_source\_ip\_condition](#input\_enable\_source\_ip\_condition) | Whether to enable source IP condition in assume role policy | `bool` | `false` | no |
| <a name="input_allowed_source_ips"></a> [allowed\_source\_ips](#input\_allowed\_source\_ips) | List of allowed source IP addresses/CIDR blocks | `list(string)` | `[]` | no |
| <a name="input_enable_ssm_access"></a> [enable\_ssm\_access](#input\_enable\_ssm\_access) | Whether to enable AWS Systems Manager access | `bool` | `true` | no |
| <a name="input_enable_cloudwatch_agent"></a> [enable\_cloudwatch\_agent](#input\_enable\_cloudwatch\_agent) | Whether to enable CloudWatch Agent permissions | `bool` | `true` | no |
| <a name="input_enable_s3_read_access"></a> [enable\_s3\_read\_access](#input\_enable\_s3\_read\_access) | Whether to enable S3 read-only access | `bool` | `false` | no |
| <a name="input_enable_parameter_store_access"></a> [enable\_parameter\_store\_access](#input\_enable\_parameter\_store\_access) | Whether to enable Parameter Store access for application parameters | `bool` | `false` | no |
| <a name="input_enable_secrets_manager_access"></a> [enable\_secrets\_manager\_access](#input\_enable\_secrets\_manager\_access) | Whether to enable Secrets Manager access for application secrets | `bool` | `false` | no |
| <a name="input_custom_policy_statements"></a> [custom\_policy\_statements](#input\_custom\_policy\_statements) | Additional IAM policy statements to attach to the role | <pre>list(object({<br/>    Sid       = optional(string)<br/>    Effect    = string<br/>    Action    = list(string)<br/>    Resource  = list(string)<br/>    Condition = optional(map(any))<br/>  }))</pre> | `[]` | no |
| <a name="input_create_example_instance"></a> [create\_example\_instance](#input\_create\_example\_instance) | Whether to create an example EC2 instance | `bool` | `false` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID for the example instance | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the example instance | `string` | `"t3.micro"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID for the example instance | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs for the example instance | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_profile_name"></a> [instance\_profile\_name](#output\_instance\_profile\_name) | Name of the IAM instance profile |
| <a name="output_instance_profile_arn"></a> [instance\_profile\_arn](#output\_instance\_profile\_arn) | ARN of the IAM instance profile |
| <a name="output_instance_role_arn"></a> [instance\_role\_arn](#output\_instance\_role\_arn) | ARN of the IAM role |
| <a name="output_instance_role_name"></a> [instance\_role\_name](#output\_instance\_role\_name) | Name of the IAM role |
| <a name="output_example_instance_id"></a> [example\_instance\_id](#output\_example\_instance\_id) | ID of the example EC2 instance (if created) |
| <a name="output_example_instance_private_ip"></a> [example\_instance\_private\_ip](#output\_example\_instance\_private\_ip) | Private IP of the example EC2 instance (if created) |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The unique ID of the IAM role |
| <a name="output_role_tags"></a> [role\_tags](#output\_role\_tags) | The tags assigned to the IAM role |
<!-- END_TF_DOCS -->
