output "role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "The unique ID of the IAM role."
  value       = aws_iam_role.this.unique_id
}

output "role_unique_id" {
  description = "The unique ID of the IAM role."
  value       = aws_iam_role.this.unique_id
}

output "create_date" {
  description = "The creation date of the IAM role."
  value       = aws_iam_role.this.create_date
}

output "role_tags" {
  description = "The tags applied to the IAM role."
  value       = aws_iam_role.this.tags_all
}
