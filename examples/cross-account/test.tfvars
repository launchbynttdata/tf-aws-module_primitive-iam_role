role_name            = "cross-account-access-role"
description          = "Role for cross-account access with MFA and external ID requirements"
max_session_duration = 7200
path                 = "/cross-account/"
statement_sid        = "CrossAccountAssumeRole"

trusted_account_arns = [
  "arn:aws:iam::020127659860:root"
]

external_id         = "test-external-id-12345"
max_mfa_age_seconds = 3600

tags = {
  Environment   = "production"
  Purpose       = "cross-account-access"
  ManagedBy     = "terraform"
  SecurityLevel = "high"
  Project       = "infrastructure"
}

policy_name = "cross-account-permissions"
