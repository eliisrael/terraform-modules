resource "aws_iam_role" "task_definition_role" {
  name = local.task_definition_role_name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = var.managed_policy_arns

  tags = merge(
    local.default_tags,
    {
      Name      = "${local.task_definition_role_name}"
      Component = "${var.component_name}"
    },
  )
}
