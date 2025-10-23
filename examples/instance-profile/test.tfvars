# Instance Profile Role Test Configuration
instance_role_name = "test-ec2-instance-role"
environment        = "test"
application_name   = "test-application"

# Security Configuration
enable_source_ip_condition = true
allowed_source_ips = [
  "10.0.0.0/8",
  "192.168.0.0/16",
  "172.16.0.0/12"
]

# AWS Service Access
enable_ssm_access             = true
enable_cloudwatch_agent       = true
enable_s3_read_access         = true
enable_parameter_store_access = true
enable_secrets_manager_access = true

# Additional custom permissions for testing
custom_policy_statements = [
  {
    Sid    = "TestDynamoDBAccess"
    Effect = "Allow"
    Action = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    Resource = [
      "arn:aws:dynamodb:us-east-1:*:table/test-*"
    ]
  },
  {
    Sid    = "TestSQSAccess"
    Effect = "Allow"
    Action = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage"
    ]
    Resource = [
      "arn:aws:sqs:us-east-1:*:test-*"
    ]
  }
]

# Example Instance Configuration
create_example_instance = false                   # Set to true when you have actual VPC infrastructure
ami_id                  = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI (us-east-1)
instance_type           = "t3.micro"
subnet_id               = null # Replace with actual subnet ID when testing
security_group_ids      = []   # Replace with actual security group IDs when testing
