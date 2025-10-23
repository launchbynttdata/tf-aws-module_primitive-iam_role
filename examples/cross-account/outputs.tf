output "cross_account_role_arn" {
  description = "The ARN of the cross-account IAM role"
  value       = module.cross_account_role.role_arn
}

output "cross_account_role_name" {
  description = "The name of the cross-account IAM role"
  value       = module.cross_account_role.role_name
}

output "cross_account_role_unique_id" {
  description = "The unique ID of the cross-account IAM role"
  value       = module.cross_account_role.role_unique_id
}

output "role_assume_command" {
  description = "Example AWS CLI command to assume this role"
  value       = "aws sts assume-role --role-arn ${module.cross_account_role.role_arn} --role-session-name cross-account-session --external-id YOUR_EXTERNAL_ID --serial-number YOUR_MFA_DEVICE --token-code YOUR_MFA_TOKEN"
}

# Standard outputs expected by test framework
output "role_arn" {
  description = "The ARN of the IAM role"
  value       = module.cross_account_role.role_arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = module.cross_account_role.role_name
}

output "role_id" {
  description = "The unique ID of the IAM role"
  value       = module.cross_account_role.role_unique_id
}

output "role_tags" {
  description = "The tags assigned to the IAM role"
  value       = module.cross_account_role.role_tags
}
