output "lambda_execution_role_arn" {
  description = "The ARN of the Lambda execution role"
  value       = module.lambda_execution_role.role_arn
}

output "lambda_execution_role_name" {
  description = "The name of the Lambda execution role"
  value       = module.lambda_execution_role.role_name
}

output "lambda_function_arn" {
  description = "The ARN of the example Lambda function (if created)"
  value       = var.create_example_lambda ? aws_lambda_function.example[0].arn : null
}

output "lambda_function_name" {
  description = "The name of the example Lambda function (if created)"
  value       = var.create_example_lambda ? aws_lambda_function.example[0].function_name : null
}

# Standard outputs expected by test framework
output "role_arn" {
  description = "The ARN of the IAM role"
  value       = module.lambda_execution_role.role_arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = module.lambda_execution_role.role_name
}

output "role_id" {
  description = "The unique ID of the IAM role"
  value       = module.lambda_execution_role.role_unique_id
}

output "role_tags" {
  description = "The tags assigned to the IAM role"
  value       = module.lambda_execution_role.role_tags
}
