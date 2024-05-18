resource "aws_lb_target_group" "product_target_group" {
  count       = var.create_api_exposition ? 1 : var.create_api_exposition_public ? 1 : 0
  name        = local.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  tags = merge(
    local.default_tags,
    {
      Name      = "${local.target_group_name}"
      Component = "${var.component_name}"
    },
  )
}
