variable "name" {
  description = "The name of the IAM role."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the IAM role."
  type        = map(string)
  default     = {}
}

variable "assume_role_policy" {
  description = "IAM assume role policy statements to include in the trust policy."
  type = list(object({
    sid     = optional(string)
    effect  = optional(string, "Allow")
    actions = list(string)

    # each statement may have multiple principal blocks
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))

    conditions = optional(list(object({
      test     = string       # e.g., "StringEquals"
      variable = string       # e.g., "aws:PrincipalTag/Team"
      values   = list(string) # e.g., ["DevOps"]
    })))
  }))
}

variable "max_session_duration" {
  description = "The maximum session duration (in seconds) for the IAM role."
  type        = number
  default     = 3600
}

variable "permission_boundary_arn" {
  description = "The ARN of the policy used to set the permissions boundary for the IAM role."
  type        = string
  default     = null
}

variable "path" {
  description = "The path for the IAM role."
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Whether to force detachment of policies when deleting the IAM role."
  type        = bool
  default     = false
}

variable "description" {
  description = "The description of the IAM role."
  type        = string
  default     = null
}
