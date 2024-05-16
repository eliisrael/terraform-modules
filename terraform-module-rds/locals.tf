locals {

  identifier         = "db-${var.product}-${var.component_name}-${var.environment}"
  username           = "postgres"
  baseParameter      = "/${var.environment}/${var.product}/${var.component_name}"
  security_group_name = "rds-${var.product}-${var.component_name}-${var.environment}"

  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-rds"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}
