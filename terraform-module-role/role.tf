resource "aws_iam_role" "role" {
  name = local.role_name

  assume_role_policy = var.assume_role_policy
  managed_policy_arns = var.managed_policy_arns

  tags = merge(
    local.default_tags,
    {
      Name      = "${local.role_name}"
    },
  )
}
