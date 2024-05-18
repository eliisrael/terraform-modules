data "aws_caller_identity" "current" {}
locals {

  cluster_name              = "ecs-cluster-${var.product}-${var.environment}"
  
  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-ecs-cluster"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}
