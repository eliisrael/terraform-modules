resource "aws_lb" "product_nlb" {
  count              = var.create_api_exposition ? 1 : 0
  name               = local.nlb_name
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb_sg[0].id]
  subnets            = data.aws_subnets.private_subnets.ids

  enable_deletion_protection = false

  tags = merge(
    local.default_tags,
    {
      Name      = "${local.nlb_name}"
      Component = "${var.component_name}"
    },
  )
}

resource "aws_lb_listener" "product_listener" {
  count             = var.create_api_exposition ? 1 : 0
  load_balancer_arn = aws_lb.product_nlb[0].arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.product_target_group[0].arn
  }

  tags = local.default_tags
}

resource "aws_security_group" "nlb_sg" {
  count       = var.create_api_exposition ? 1 : 0
  name        = local.nlb_name
  description = "Security Group created for nlb ${local.nlb_name}"
  vpc_id      = var.vpc_id

  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name      = "${local.nlb_name}"
      Component = "${var.component_name}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress" {
  count             = var.create_api_exposition ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nlb_sg[0].id
}

resource "aws_security_group_rule" "ingress-product" {
  count             = var.create_api_exposition ? 1 : 0
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "TCP"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.nlb_sg[0].id

}

resource "aws_security_group_rule" "ingress-nlb-listener" {
  count             = var.create_api_exposition ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nlb_sg[0].id

}
