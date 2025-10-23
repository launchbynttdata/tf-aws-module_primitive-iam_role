# Lambda Execution Role Example

This example demonstrates creating an IAM role for AWS Lambda functions with comprehensive permissions and features.

## Features Demonstrated

- **Service principal assumption**: Lambda service can assume this role
- **Name prefix**: Automatically generated unique role names
- **AWS managed policy attachments**: Basic execution and VPC access
- **Custom policy creation**: Application-specific permissions
- **Conditional policy attachment**: VPC access only when needed
- **Lambda function integration**: Example function using the role

## Capabilities Tested

1. **Basic Lambda execution**: CloudWatch Logs access
2. **VPC access**: Network interfaces and subnets (optional)
3. **Parameter Store access**: Application-specific parameters
4. **Secrets Manager access**: Application secrets
5. **Custom permissions**: User-defined policy statements

## Usage

```bash
# Basic usage
terraform init
terraform plan -var="environment=dev"
terraform apply

# With VPC access and example Lambda
terraform apply \
  -var="environment=prod" \
  -var="enable_vpc_access=true" \
  -var="create_example_lambda=true"

# With custom permissions
terraform apply \
  -var="additional_permissions=[{
    sid       = \"S3Access\"
    actions   = [\"s3:GetObject\", \"s3:PutObject\"]
    resources = [\"arn:aws:s3:::my-bucket/*\"]
  }]"
```

## Testing

This example tests:

- Service principal configuration for Lambda
- AWS managed policy attachments
- Custom policy generation with conditions
- Lambda function deployment
- Role name prefix functionality

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_execution_role"></a> [lambda\_execution\_role](#module\_lambda\_execution\_role) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.lambda_custom_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_vpc_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.example_lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for the Lambda execution role name | `string` | `"lambda-execution-"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Lambda execution role | `string` | `"Execution role for Lambda functions with VPC and CloudWatch access"` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds | `number` | `3600` | no |
| <a name="input_statement_sid"></a> [statement\_sid](#input\_statement\_sid) | SID for the assume role policy statement | `string` | `"LambdaServiceAssumeRole"` | no |
| <a name="input_service_identifiers"></a> [service\_identifiers](#input\_service\_identifiers) | List of service identifiers that can assume this role | `list(string)` | <pre>[<br/>  "lambda.amazonaws.com"<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the Lambda execution role | `map(string)` | `{}` | no |
| <a name="input_custom_policy_name"></a> [custom\_policy\_name](#input\_custom\_policy\_name) | Name for the custom Lambda permissions policy | `string` | `"lambda-custom-permissions"` | no |
| <a name="input_enable_vpc_access"></a> [enable\_vpc\_access](#input\_enable\_vpc\_access) | Whether to enable VPC access for Lambda functions | `bool` | `false` | no |
| <a name="input_create_example_lambda"></a> [create\_example\_lambda](#input\_create\_example\_lambda) | Whether to create an example Lambda function | `bool` | `false` | no |
| <a name="input_additional_permissions"></a> [additional\_permissions](#input\_additional\_permissions) | Additional permissions to grant to the Lambda execution role | <pre>list(object({<br/>    sid       = string<br/>    actions   = list(string)<br/>    resources = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_lambda_filename"></a> [lambda\_filename](#input\_lambda\_filename) | Path to the Lambda deployment package | `string` | `"example_lambda.zip"` | no |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | Name of the Lambda function | `string` | `"example-lambda-function"` | no |
| <a name="input_lambda_handler"></a> [lambda\_handler](#input\_lambda\_handler) | Lambda function handler | `string` | `"index.handler"` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda function runtime | `string` | `"python3.9"` | no |
| <a name="input_lambda_environment_variables"></a> [lambda\_environment\_variables](#input\_lambda\_environment\_variables) | Environment variables for the Lambda function | `map(string)` | <pre>{<br/>  "ENVIRONMENT": "development"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_execution_role_arn"></a> [lambda\_execution\_role\_arn](#output\_lambda\_execution\_role\_arn) | The ARN of the Lambda execution role |
| <a name="output_lambda_execution_role_name"></a> [lambda\_execution\_role\_name](#output\_lambda\_execution\_role\_name) | The name of the Lambda execution role |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | The ARN of the example Lambda function (if created) |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the example Lambda function (if created) |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The unique ID of the IAM role |
| <a name="output_role_tags"></a> [role\_tags](#output\_role\_tags) | The tags assigned to the IAM role |
<!-- END_TF_DOCS -->
