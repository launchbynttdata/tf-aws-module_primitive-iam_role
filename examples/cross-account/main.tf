module "cross_account_role" {
  source = "../../"

  name                 = var.role_name
  description          = var.description
  max_session_duration = var.max_session_duration
  path                 = var.path

  assume_role_policy = [
    {
      sid     = var.statement_sid
      effect  = "Allow"
      actions = ["sts:AssumeRole"]
      principals = [
        {
          type        = "AWS"
          identifiers = var.trusted_account_arns
        }
      ]
      conditions = [
        {
          test     = "Bool"
          variable = "aws:MultiFactorAuthPresent"
          values   = ["true"]
        },
        {
          test     = "StringEquals"
          variable = "sts:ExternalId"
          values   = [var.external_id]
        },
        {
          test     = "NumericLessThan"
          variable = "aws:MultiFactorAuthAge"
          values   = [tostring(var.max_mfa_age_seconds)]
        }
      ]
    }
  ]

  tags = var.tags
}

# Example of attaching a custom policy to the role
resource "aws_iam_role_policy" "cross_account_policy" {
  name = var.policy_name
  role = module.cross_account_role.role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadOnlyAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "iam:ListRoles",
          "iam:GetRole"
        ]
        Resource = "*"
      }
    ]
  })
}
