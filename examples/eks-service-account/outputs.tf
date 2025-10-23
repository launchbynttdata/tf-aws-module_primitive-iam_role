output "eks_service_account_role_arn" {
  description = "The ARN of the EKS service account role"
  value       = module.eks_service_account_role.role_arn
}

output "eks_service_account_role_name" {
  description = "The name of the EKS service account role"
  value       = module.eks_service_account_role.role_name
}

output "kubernetes_service_account_annotation" {
  description = "Annotation to add to the Kubernetes service account"
  value = {
    "eks.amazonaws.com/role-arn" = module.eks_service_account_role.role_arn
  }
}

output "kubernetes_service_account_yaml" {
  description = "YAML manifest for the Kubernetes service account"
  value       = <<-EOF
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: ${var.service_account_name}
      namespace: ${var.namespace}
      annotations:
        eks.amazonaws.com/role-arn: ${module.eks_service_account_role.role_arn}
  EOF
}

# Standard outputs expected by test framework
output "role_arn" {
  description = "The ARN of the IAM role"
  value       = module.eks_service_account_role.role_arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = module.eks_service_account_role.role_name
}

output "role_id" {
  description = "The unique ID of the IAM role"
  value       = module.eks_service_account_role.role_unique_id
}

output "role_tags" {
  description = "The tags assigned to the IAM role"
  value       = module.eks_service_account_role.role_tags
}
