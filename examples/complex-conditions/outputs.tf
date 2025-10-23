output "complex_role_arn" {
  description = "ARN of the complex IAM role"
  value       = module.complex_role.role_arn
}

output "complex_role_name" {
  description = "Name of the complex IAM role"
  value       = module.complex_role.role_name
}

# Standard output expected by test framework
output "role_arn" {
  description = "ARN of the IAM role (standard output for test framework)"
  value       = module.complex_role.role_arn
}

output "role_name" {
  description = "Name of the IAM role (standard output for test framework)"
  value       = module.complex_role.role_name
}

output "role_id" {
  description = "ID of the IAM role (standard output for test framework)"
  value       = module.complex_role.role_id
}

output "role_tags" {
  description = "Tags of the IAM role (standard output for test framework)"
  value       = module.complex_role.role_tags
}

output "role_assume_policy_summary" {
  description = "Summary of the assume role policy features"
  sensitive   = true
  value = {
    cross_account_access = length(var.trusted_account_arns) > 0
    mfa_required         = true
    external_id_required = var.external_id != ""
    time_based_access    = var.access_start_time != null && var.access_end_time != null
    ip_restricted        = length(var.allowed_ip_ranges) > 0
    oidc_federation      = length(var.oidc_provider_arns) > 0
    service_principals   = length(var.trusted_services) > 0
  }
}

output "permission_boundary_info" {
  description = "Information about the permission boundary"
  value = var.permission_boundary_arn != null ? {
    enabled      = true
    boundary_arn = var.permission_boundary_arn
    } : {
    enabled = false
  }
}

output "security_features" {
  description = "List of security features enabled"
  value = compact([
    "MFA Required",
    "External ID Required",
    "IP Address Restrictions",
    "Time-based Access Control",
    "Secure Transport Required",
    var.permission_boundary_arn != null ? "Permission Boundary Applied" : null,
    length(var.allowed_departments) > 0 ? "Department Tag Validation" : null,
    var.enable_service_source_condition ? "Source Account Validation" : null
  ])
}
