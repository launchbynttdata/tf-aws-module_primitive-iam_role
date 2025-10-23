# Complex Conditions Role Test Configuration
project_name         = "test-complex-iam"
environment          = "test"
max_session_duration = 7200 # 2 hours

# Permissions Boundary (optional - set to null for testing without boundary)
permission_boundary_arn = null

# Cross-Account Access Configuration
trusted_account_arns = [
  "arn:aws:iam::020127659860:root" # Current test account
]
max_mfa_age_seconds = 3600 # 1 hour
external_id         = "test-external-id-12345"

# Principal Tag Conditions
allowed_departments = [
  "Engineering",
  "DevOps",
  "Security",
  "Platform"
]

# Time-based Access Window
access_start_time = "2024-01-01T00:00:00Z"
access_end_time   = "2025-12-31T23:59:59Z"

# IP-based Access Control
allowed_ip_ranges = [
  "10.0.0.0/8",     # Private network
  "172.16.0.0/12",  # Private network
  "192.168.0.0/16", # Private network
  "203.0.113.0/24"  # Example public range for testing
]

# OIDC Federation (e.g., GitHub Actions)
oidc_provider_arns = [
  "arn:aws:iam::020127659860:oidc-provider/token.actions.githubusercontent.com"
]
oidc_provider_url = "token.actions.githubusercontent.com"

allowed_oidc_subjects = [
  "repo:myorg/test-repo:ref:refs/heads/main",
  "repo:myorg/test-repo:ref:refs/heads/develop",
  "repo:myorg/*:ref:refs/heads/main"
]

trusted_repositories = [
  "myorg/test-repo",
  "myorg/test-infrastructure",
  "myorg/test-applications"
]

# Service Principal Configuration
trusted_services = [
  "lambda.amazonaws.com",
  "ec2.amazonaws.com",
  "ecs-tasks.amazonaws.com",
  "codebuild.amazonaws.com"
]

enable_service_source_condition = true
source_account_id               = "020127659860" # Current test account

allowed_source_arns = [
  "arn:aws:lambda:us-east-1:020127659860:function:test-*",
  "arn:aws:ec2:us-east-1:020127659860:instance/*",
  "arn:aws:ecs:us-east-1:020127659860:task/*"
]

# Regional Restrictions
allowed_regions = [
  "us-east-1",
  "us-west-2",
  "eu-west-1"
]
