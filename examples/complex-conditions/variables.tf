variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600
  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Session duration must be between 1 hour (3600) and 12 hours (43200)."
  }
}

variable "permission_boundary_arn" {
  description = "ARN of the permissions boundary policy"
  type        = string
  default     = null
}

variable "trusted_account_arns" {
  description = "List of trusted AWS account ARNs"
  type        = list(string)
  default     = []
}

variable "max_mfa_age_seconds" {
  description = "Maximum age of MFA token in seconds"
  type        = number
  default     = 3600
}

variable "external_id" {
  description = "External ID for cross-account access"
  type        = string
  sensitive   = true
}

variable "allowed_departments" {
  description = "List of allowed department values in principal tags"
  type        = list(string)
  default     = ["Engineering", "DevOps", "Security"]
}

variable "access_start_time" {
  description = "Start time for access window (ISO 8601 format)"
  type        = string
  default     = "2024-01-01T00:00:00Z"
}

variable "access_end_time" {
  description = "End time for access window (ISO 8601 format)"
  type        = string
  default     = "2026-12-31T23:59:59Z"
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges in CIDR notation"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "oidc_provider_arns" {
  description = "List of OIDC provider ARNs for web identity federation"
  type        = list(string)
  default     = []
}

variable "oidc_provider_url" {
  description = "OIDC provider URL (without https://)"
  type        = string
  default     = "token.actions.githubusercontent.com"
}

variable "allowed_oidc_subjects" {
  description = "List of allowed OIDC subject patterns"
  type        = list(string)
  default     = ["repo:myorg/*:ref:refs/heads/main"]
}

variable "trusted_repositories" {
  description = "List of trusted repository names for OIDC"
  type        = list(string)
  default     = []
}

variable "trusted_services" {
  description = "List of trusted AWS service principals"
  type        = list(string)
  default     = ["lambda.amazonaws.com", "ec2.amazonaws.com"]
}

variable "enable_service_source_condition" {
  description = "Whether to enable source account/ARN conditions for service principals"
  type        = bool
  default     = true
}

variable "source_account_id" {
  description = "Source account ID for service principal conditions"
  type        = string
  default     = null
}

variable "allowed_source_arns" {
  description = "List of allowed source ARN patterns"
  type        = list(string)
  default     = []
}

variable "allowed_regions" {
  description = "List of allowed AWS regions"
  type        = list(string)
  default     = ["us-east-1", "us-west-2"]
}
