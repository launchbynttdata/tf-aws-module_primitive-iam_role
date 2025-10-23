output "role_arn" {
  description = "The ARN of the IAM role."
  value       = module.aws_iam_role.role_arn
}

output "role_name" {
  description = "The name of the IAM role."
  value       = module.aws_iam_role.role_name
}

output "role_id" {
  description = "The ID of the IAM role."
  value       = module.aws_iam_role.role_id
}

output "role_unique_id" {
  description = "The unique ID of the IAM role."
  value       = module.aws_iam_role.role_unique_id
}

output "role_tags" {
  description = "The tags applied to the IAM role."
  value       = module.aws_iam_role.role_tags
}
