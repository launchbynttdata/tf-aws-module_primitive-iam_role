variable "instance_role_name" {
  description = "Name for the EC2 instance role"
  type        = string
  default     = "ec2-instance-role"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "application_name" {
  description = "Name of the application this instance will run"
  type        = string
  default     = null
}

variable "enable_source_ip_condition" {
  description = "Whether to enable source IP condition in assume role policy"
  type        = bool
  default     = false
}

variable "allowed_source_ips" {
  description = "List of allowed source IP addresses/CIDR blocks"
  type        = list(string)
  default     = []
}

variable "enable_ssm_access" {
  description = "Whether to enable AWS Systems Manager access"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_agent" {
  description = "Whether to enable CloudWatch Agent permissions"
  type        = bool
  default     = true
}

variable "enable_s3_read_access" {
  description = "Whether to enable S3 read-only access"
  type        = bool
  default     = false
}

variable "enable_parameter_store_access" {
  description = "Whether to enable Parameter Store access for application parameters"
  type        = bool
  default     = false
}

variable "enable_secrets_manager_access" {
  description = "Whether to enable Secrets Manager access for application secrets"
  type        = bool
  default     = false
}

variable "custom_policy_statements" {
  description = "Additional IAM policy statements to attach to the role"
  type = list(object({
    Sid       = optional(string)
    Effect    = string
    Action    = list(string)
    Resource  = list(string)
    Condition = optional(map(any))
  }))
  default = []
}

variable "create_example_instance" {
  description = "Whether to create an example EC2 instance"
  type        = bool
  default     = false
}

variable "ami_id" {
  description = "AMI ID for the example instance"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type for the example instance"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID for the example instance"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security group IDs for the example instance"
  type        = list(string)
  default     = []
}
