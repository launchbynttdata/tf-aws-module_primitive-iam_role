name                 = "example-role"
max_session_duration = 7200
description          = "Example IAM role for EC2 instances"
path                 = null

assume_role_policy = [
  {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals = [
      {
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }
    ]
  }
]

tags = {
  Environment = "dev"
  Project     = "example"
  ManagedBy   = "terraform"
}

permission_boundary_arn = null
force_detach_policies   = false
