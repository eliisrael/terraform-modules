locals {
role_name = "${var.name}-${var.environment}"
  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-role"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}