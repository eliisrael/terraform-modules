resource "aws_ssm_parameter" "db_password" {
  name        = "${local.baseParameter}/db_password"
  description = "Create by Terraform."
  type        = "SecureString"
  value       = aws_db_instance.default.password

  tags = local.default_tags
}

resource "aws_ssm_parameter" "db_username" {
  name        = "${local.baseParameter}/db_username"
  description = "Create by Terraform."
  type        = "String"
  value       = aws_db_instance.default.username

  tags = local.default_tags
}





