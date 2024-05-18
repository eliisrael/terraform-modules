resource "aws_ecs_service" "product_service" {
  count           = var.create_api_exposition ? 1 : var.create_api_exposition_public ? 1 : 0
  name            = local.container_name
  cluster         = data.aws_ecs_cluster.product_cluster.id
  task_definition = aws_ecs_task_definition.product_task.arn
  desired_count   = 1

  launch_type = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.product_target_group[0].arn
    container_name   = local.container_name
    container_port   = var.container_port
  }
  network_configuration {
    subnets          = data.aws_subnets.private_subnets.ids
    security_groups  = [aws_security_group.service_sg.id]
    assign_public_ip = true
  }


  tags = merge(
    local.default_tags,
    {
      Name      = "${local.container_name}"
      Component = "${var.component_name}"
    },
  )
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_service" "product_service_no_expo" {
  count           = var.create_api_exposition ? 0 : var.create_api_exposition_public ? 0 : 1
  name            = local.container_name
  cluster         = data.aws_ecs_cluster.product_cluster.id
  task_definition = aws_ecs_task_definition.product_task.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.private_subnets.ids
    security_groups  = [aws_security_group.service_sg.id]
    assign_public_ip = true
  }

  tags = merge(
    local.default_tags,
    {
      Name      = "${local.container_name}"
      Component = "${var.component_name}"
    },
  )
  lifecycle {
    ignore_changes = [task_definition]
  }
}


resource "aws_security_group" "service_sg" {

  name        = local.container_name
  description = "Security Group created for nlb ${local.container_name}"
  vpc_id      = var.vpc_id

  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name      = "${local.container_name}"
      Component = "${var.component_name}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress_product" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.service_sg.id
}

resource "aws_security_group_rule" "ingress_product" {
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.service_sg.id

}



