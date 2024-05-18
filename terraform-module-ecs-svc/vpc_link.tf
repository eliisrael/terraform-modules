resource "aws_api_gateway_vpc_link" "product_vpc_link" {
  count       = var.create_api_exposition ? 1 : 0
  name        = local.vpc_link_name
  description = "VPC Link for API Gateway"
  target_arns = [aws_lb.product_nlb[0].arn]

  tags = merge(
    local.default_tags,
    {
      Name      = "${local.vpc_link_name}"
      Component = "${var.component_name}"
    },
  )
}
