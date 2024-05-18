resource "aws_ecs_task_definition" "product_task" {
  family                   = local.task_family_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.task_definition_role.arn
  execution_role_arn       = aws_iam_role.task_definition_role.arn
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = var.image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${local.log_group_name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "ecs"
          "awslogs-create-group" : "true"
        }
      }
    },

  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = merge(
    local.default_tags,
    {
      Name      = "${local.task_family_name}"
      Component = "${var.component_name}"
    },
  )


}
