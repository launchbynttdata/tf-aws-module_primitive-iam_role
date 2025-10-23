output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.this.name
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.this.arn
}

output "instance_role_arn" {
  description = "ARN of the IAM role"
  value       = module.ec2_instance_role.role_arn
}

output "instance_role_name" {
  description = "Name of the IAM role"
  value       = module.ec2_instance_role.role_name
}

output "example_instance_id" {
  description = "ID of the example EC2 instance (if created)"
  value       = var.create_example_instance ? aws_instance.example[0].id : null
}

output "example_instance_private_ip" {
  description = "Private IP of the example EC2 instance (if created)"
  value       = var.create_example_instance ? aws_instance.example[0].private_ip : null
}

# Standard outputs expected by test framework
output "role_arn" {
  description = "The ARN of the IAM role"
  value       = module.ec2_instance_role.role_arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = module.ec2_instance_role.role_name
}

output "role_id" {
  description = "The unique ID of the IAM role"
  value       = module.ec2_instance_role.role_unique_id
}

output "role_tags" {
  description = "The tags assigned to the IAM role"
  value       = module.ec2_instance_role.role_tags
}
