resource "aws_cloudwatch_log_group" "product_log_group" {
  count = var.create_codebuild ? 1 : 0
  name  = "codebuild/${local.project_name}"

  tags = merge(
    local.default_tags,
    {
      Name      = "codebuild/${local.project_name}"
      Component = "${var.component_name}"
    },
  )
}
