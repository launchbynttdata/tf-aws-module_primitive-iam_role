# Lambda Execution Role Test Configuration
name_prefix          = "test-lambda-execution-"
description          = "Test Lambda execution role with comprehensive permissions"
max_session_duration = 7200
statement_sid        = "TestLambdaServiceAssumeRole"
service_identifiers  = ["lambda.amazonaws.com"]

# Environment and Tagging
environment = "test"
cost_center = "engineering-test"

tags = {
  Environment = "test"
  Project     = "terraform-module-testing"
  Purpose     = "lambda-execution-role-test"
  Owner       = "platform-team"
  CostCenter  = "engineering-test"
  ManagedBy   = "terraform"
}

# Custom Policy Configuration
custom_policy_name = "test-lambda-comprehensive-permissions"

# VPC Access Configuration
enable_vpc_access = true

# Example Lambda Function Configuration
create_example_lambda = true
lambda_filename       = "test_lambda.zip"
lambda_function_name  = "test-lambda-with-comprehensive-role"
lambda_handler        = "lambda_function.lambda_handler"
lambda_runtime        = "python3.11"

lambda_environment_variables = {
  ENVIRONMENT = "test"
  LOG_LEVEL   = "INFO"
  REGION      = "us-east-1"
}

# Additional Permissions for Testing
additional_permissions = [
  {
    sid = "TestS3Access"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::test-lambda-bucket/*"
    ]
  },
  {
    sid = "TestDynamoDBAccess"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:us-east-1:*:table/test-table"
    ]
  }
]
