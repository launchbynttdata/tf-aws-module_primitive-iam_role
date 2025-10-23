variable "role_name" {
  description = "Name of the cross-account IAM role"
  type        = string
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = "Cross-account access role with MFA and external ID requirements"
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 14400
}

variable "path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/cross-account/"
}

variable "statement_sid" {
  description = "SID for the assume role policy statement"
  type        = string
  default     = "CrossAccountAssumeRole"
}

variable "trusted_account_arns" {
  description = "List of trusted AWS account ARNs that can assume this role"
  type        = list(string)
}

variable "external_id" {
  description = "External ID for additional security when assuming the role"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.external_id) >= 8 && length(var.external_id) <= 64
    error_message = "External ID must be between 8 and 64 characters long."
  }
}

variable "max_mfa_age_seconds" {
  description = "Maximum age of MFA token in seconds"
  type        = number
  default     = 3600
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Name for the attached policy"
  type        = string
  default     = "cross-account-permissions"
}
