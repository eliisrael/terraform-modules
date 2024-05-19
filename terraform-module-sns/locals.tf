
locals {


  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-sns"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}
