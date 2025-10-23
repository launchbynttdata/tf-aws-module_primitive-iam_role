data "aws_iam_policy_document" "assume_role" {
  dynamic "statement" {
    for_each = var.assume_role_policy
    content {
      sid     = try(statement.value.sid, null)
      effect  = try(statement.value.effect, "Allow")
      actions = statement.value.actions

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.conditions != null ? statement.value.conditions : []
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}
resource "aws_iam_role" "this" {
  name                  = var.name
  name_prefix           = var.name_prefix
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  description           = var.description
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  path                  = var.path
  permissions_boundary  = var.permission_boundary_arn
  tags                  = local.tags
}
