module "lambda_execution_role" {
  source = "../../"

  name_prefix          = var.name_prefix
  description          = var.description
  max_session_duration = var.max_session_duration

  assume_role_policy = [
    {
      sid     = var.statement_sid
      effect  = "Allow"
      actions = ["sts:AssumeRole"]
      principals = [
        {
          type        = "Service"
          identifiers = var.service_identifiers
        }
      ]
    }
  ]

  tags = var.tags
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = module.lambda_execution_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" # pragma: allowlist secret
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  count = var.enable_vpc_access ? 1 : 0

  role       = module.lambda_execution_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole" # pragma: allowlist secret
}

# Custom policy for specific Lambda permissions
resource "aws_iam_role_policy" "lambda_custom_permissions" {
  count = length(var.additional_permissions) > 0 ? 1 : 0

  name = var.custom_policy_name
  role = module.lambda_execution_role.role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for permission in var.additional_permissions : {
        Sid      = permission.sid
        Effect   = "Allow"
        Action   = permission.actions
        Resource = permission.resources
      }
    ]
  })
}

# Example Lambda function using this role
resource "aws_lambda_function" "example" {
  count = var.create_example_lambda ? 1 : 0

  filename         = var.lambda_filename
  function_name    = var.lambda_function_name
  role             = module.lambda_execution_role.role_arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.example_lambda[0].output_base64sha256

  environment {
    variables = var.lambda_environment_variables
  }

  tags = module.lambda_execution_role.role_tags
}

# Create example Lambda deployment package
data "archive_file" "example_lambda" {
  count = var.create_example_lambda ? 1 : 0

  type        = "zip"
  output_path = "example_lambda.zip"
  source {
    content  = <<EOF
import json
import os

def handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Hello from Lambda!',
            'environment': os.environ.get('ENVIRONMENT', 'unknown')
        })
    }
EOF
    filename = "index.py"
  }
}
