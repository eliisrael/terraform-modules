resource "aws_lb" "product_alb" {
  count              = var.create_api_exposition_public ? 1 : 0
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg[0].id]
  subnets            = data.aws_subnets.public_subnets.ids

  enable_deletion_protection = false

  tags = merge(
    local.default_tags,
    {
      Name      = "${local.alb_name}"
      Component = "${var.component_name}"
    },
  )
}

resource "aws_lb_listener" "product_listener_alb" {
  count             = var.create_api_exposition_public ? 1 : 0
  load_balancer_arn = aws_lb.product_alb[0].arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.loadpass.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.product_target_group[0].arn

  }



  tags = local.default_tags
}


# resource "aws_lb_listener_certificate" "product_alb_certificate" {
#   listener_arn    = aws_lb_listener.product_listener_alb[0].arn
#   certificate_arn = data.aws_acm_certificate.loadpass.arn
# }

resource "aws_security_group" "alb_sg" {
  count       = var.create_api_exposition_public ? 1 : 0
  name        = local.alb_name
  description = "Security Group created for alb ${local.alb_name}"
  vpc_id      = var.vpc_id

  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name      = "${local.alb_name}"
      Component = "${var.component_name}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress_alb" {
  count             = var.create_api_exposition_public ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg[0].id
}

# resource "aws_security_group_rule" "ingress-product_alb" {
#   count             = var.create_api_exposition_public ? 1 : 0
#   type              = "ingress"
#   from_port         = var.container_port
#   to_port           = var.container_port
#   protocol          = "TCP"
#   cidr_blocks       = ["10.0.0.0/16"]
#   security_group_id = aws_security_group.alb_sg[0].id

# }

resource "aws_security_group_rule" "ingress-alb-listener" {
  count             = var.create_api_exposition_public ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg[0].id

}
