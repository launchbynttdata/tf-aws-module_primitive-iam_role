module "aws_iam_role" {
  source = "../../"

  name                    = var.name
  max_session_duration    = var.max_session_duration
  assume_role_policy      = var.assume_role_policy
  tags                    = var.tags
  permission_boundary_arn = var.permission_boundary_arn
  path                    = var.path
  description             = var.description
  force_detach_policies   = var.force_detach_policies
}
