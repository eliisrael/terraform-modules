resource "aws_db_parameter_group" "default" {
  count = var.create_postgres_db_parameter_group ? 1 : 0

  name   = "postgres16-default"
  family = "postgres16"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }

  parameter {
    name  = "password_encryption"
    value = "md5"
  }
}
