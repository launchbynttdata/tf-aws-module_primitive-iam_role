variable "name_prefix" {
  description = "Prefix for the Lambda execution role name"
  type        = string
  default     = "lambda-execution-"
}

variable "description" {
  description = "Description of the Lambda execution role"
  type        = string
  default     = "Execution role for Lambda functions with VPC and CloudWatch access"
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600
}

variable "statement_sid" {
  description = "SID for the assume role policy statement"
  type        = string
  default     = "LambdaServiceAssumeRole"
}

variable "service_identifiers" {
  description = "List of service identifiers that can assume this role"
  type        = list(string)
  default     = ["lambda.amazonaws.com"]
}

variable "tags" {
  description = "Tags to apply to the Lambda execution role"
  type        = map(string)
  default     = {}
}

# variable "environment" {
#   description = "Environment name (e.g., dev, staging, prod)"
#   type        = string
#   default     = "dev"
# }

# variable "cost_center" {
#   description = "Cost center for billing purposes"
#   type        = string
#   default     = "engineering"
# }

variable "custom_policy_name" {
  description = "Name for the custom Lambda permissions policy"
  type        = string
  default     = "lambda-custom-permissions"
}

variable "enable_vpc_access" {
  description = "Whether to enable VPC access for Lambda functions"
  type        = bool
  default     = false
}

variable "create_example_lambda" {
  description = "Whether to create an example Lambda function"
  type        = bool
  default     = false
}

variable "additional_permissions" {
  description = "Additional permissions to grant to the Lambda execution role"
  type = list(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for perm in var.additional_permissions :
      length(perm.sid) > 0 && length(perm.actions) > 0 && length(perm.resources) > 0
    ])
    error_message = "Each permission must have a non-empty sid, actions, and resources."
  }
}

variable "lambda_filename" {
  description = "Path to the Lambda deployment package"
  type        = string
  default     = "example_lambda.zip"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "example-lambda-function"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "Lambda function runtime"
  type        = string
  default     = "python3.9"
}

variable "lambda_environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default = {
    ENVIRONMENT = "development"
  }
}
