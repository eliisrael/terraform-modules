resource "aws_db_instance" "default" {
  identifier             = local.identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  username               = local.username
  password               = random_string.password.result
  db_subnet_group_name   = var.subnet_group_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = var.publicly_accessible
  parameter_group_name   = var.create_postgres_db_parameter_group ? aws_db_parameter_group.default[0].name : null

  tags = merge(
    local.default_tags,
    {
      Name = local.identifier

    },
  )

  lifecycle {
    ignore_changes = [password, engine_version]
  }
}


resource "random_string" "password" {
  length  = 16
  special = false
}
