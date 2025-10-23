locals {
  # Common tags
  common_tags = {
    Environment   = var.environment
    ManagedBy     = "terraform"
    Project       = var.project_name
    SecurityLevel = "high"
  }
}

module "complex_role" {
  source = "../../"

  name                    = "${var.project_name}-${var.environment}-complex-role"
  description             = "Complex IAM role with multiple conditions and advanced features"
  max_session_duration    = var.max_session_duration
  path                    = "/complex/"
  permission_boundary_arn = var.permission_boundary_arn
  force_detach_policies   = true

  assume_role_policy = [
    # First statement: Cross-account access with multiple conditions
    {
      sid     = "CrossAccountAccessWithConditions"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]
      principals = [
        {
          type        = "AWS"
          identifiers = var.trusted_account_arns
        }
      ]
      conditions = [
        # Require MFA
        {
          test     = "Bool"
          variable = "aws:MultiFactorAuthPresent"
          values   = ["true"]
        },
        # MFA must be recent
        {
          test     = "NumericLessThan"
          variable = "aws:MultiFactorAuthAge"
          values   = [tostring(var.max_mfa_age_seconds)]
        },
        # External ID for additional security
        {
          test     = "StringEquals"
          variable = "sts:ExternalId"
          values   = [var.external_id]
        },
        # Require specific user tags
        {
          test     = "StringEquals"
          variable = "aws:PrincipalTag/Department"
          values   = var.allowed_departments
        },
        # Time-based access control
        {
          test     = "DateGreaterThan"
          variable = "aws:CurrentTime"
          values   = [var.access_start_time]
        },
        {
          test     = "DateLessThan"
          variable = "aws:CurrentTime"
          values   = [var.access_end_time]
        },
        # IP address restriction
        {
          test     = "IpAddress"
          variable = "aws:SourceIp"
          values   = var.allowed_ip_ranges
        },
        # Require secure transport
        {
          test     = "Bool"
          variable = "aws:SecureTransport"
          values   = ["true"]
        }
      ]
    },
    # Second statement: OIDC federation for CI/CD
    {
      sid     = "OIDCFederationForCICD"
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals = [
        {
          type        = "Federated"
          identifiers = var.oidc_provider_arns
        }
      ]
      conditions = [
        # Verify audience
        {
          test     = "StringEquals"
          variable = "${var.oidc_provider_url}:aud"
          values   = ["sts.amazonaws.com"]
        },
        # Verify subject matches allowed patterns
        {
          test     = "StringLike"
          variable = "${var.oidc_provider_url}:sub"
          values   = var.allowed_oidc_subjects
        },
        # Verify token is from trusted repositories
        {
          test     = "StringEquals"
          variable = "${var.oidc_provider_url}:repository"
          values   = var.trusted_repositories
        }
      ]
    },
    # Third statement: Service principals for specific services
    {
      sid     = "ServicePrincipals"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]
      principals = [
        {
          type        = "Service"
          identifiers = var.trusted_services
        }
      ]
      conditions = var.enable_service_source_condition ? [
        {
          test     = "StringEquals"
          variable = "aws:SourceAccount"
          values   = [var.source_account_id]
        },
        {
          test     = "ArnLike"
          variable = "aws:SourceArn"
          values   = var.allowed_source_arns
        }
      ] : []
    }
  ]

  tags = local.common_tags
}

# # Permission boundary policy (if specified)
# data "aws_iam_policy" "permission_boundary" {
#   count = var.permission_boundary_arn != null ? 1 : 0
#   arn   = var.permission_boundary_arn
# }

# Example policy attachments
resource "aws_iam_role_policy" "time_based_access" {
  name = "time-based-access-policy"
  role = module.complex_role.role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "TimeBasedS3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.project_name}-${var.environment}-*/*"
        Condition = {
          DateGreaterThan = {
            "aws:CurrentTime" = var.access_start_time
          }
          DateLessThan = {
            "aws:CurrentTime" = var.access_end_time
          }
          StringEquals = {
            "s3:x-amz-server-side-encryption" = "AES256"
          }
        }
      },
      {
        Sid    = "ConditionalSecretAccess"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "arn:aws:secretsmanager:*:*:secret:${var.project_name}/${var.environment}/*"
        Condition = {
          StringEquals = {
            "aws:PrincipalTag/Project"     = var.project_name
            "aws:PrincipalTag/Environment" = var.environment
          }
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      },
      {
        Sid    = "TagBasedEC2Access"
        Effect = "Allow"
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Project"     = var.project_name
            "ec2:ResourceTag/Environment" = var.environment
          }
        }
      }
    ]
  })
}

# CloudWatch Logs policy with conditions
resource "aws_iam_role_policy" "cloudwatch_logs_conditional" {
  name = "cloudwatch-logs-conditional"
  role = module.complex_role.role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CreateLogGroups"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/${var.project_name}/${var.environment}/*"
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = var.allowed_regions
          }
        }
      },
      {
        Sid    = "WriteToLogStreams"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/${var.project_name}/${var.environment}/*:log-stream:*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.source_account_id
          }
        }
      }
    ]
  })
}
