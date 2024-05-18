resource "aws_cloudwatch_log_group" "product_log_group" {
  name = local.log_group_name

  tags = merge(
    local.default_tags,
    {
      Name      = "${local.log_group_name}"
      Component = "${var.component_name}"
    },
  )
}