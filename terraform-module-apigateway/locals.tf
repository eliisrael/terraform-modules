data "aws_caller_identity" "current" {}
locals {
  api_name    = "gtw-${var.component_name}-${var.product}-${var.environment}"
  path_list   = distinct(var.resources.*.path)
  method_list = var.resources.*.method
  path_root   = contains(local.path_list, "") && var.proxy_integration == false ? index(local.path_list, "") : null
  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-apigateway"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}
