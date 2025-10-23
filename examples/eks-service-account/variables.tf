variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the service account"
  type        = string
  default     = "default"
}

variable "oidc_provider_url" {
  description = "OIDC provider URL for the EKS cluster (without https://)"
  type        = string
  validation {
    condition     = can(regex("^oidc\\.eks\\.", var.oidc_provider_url))
    error_message = "OIDC provider URL must be a valid EKS OIDC issuer URL."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "enable_load_balancer_controller" {
  description = "Whether to enable AWS Load Balancer Controller permissions"
  type        = bool
  default     = false
}

variable "enable_cluster_autoscaler" {
  description = "Whether to enable Cluster Autoscaler permissions"
  type        = bool
  default     = false
}

variable "custom_policy_statements" {
  description = "Additional IAM policy statements to attach to the role"
  type = list(object({
    Effect    = string
    Action    = list(string)
    Resource  = any
    Condition = optional(map(any))
  }))
  default = []
}
