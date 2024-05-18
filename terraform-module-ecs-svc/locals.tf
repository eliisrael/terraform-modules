data "aws_caller_identity" "current" {}
locals {

  cluster_name              = "ecs-cluster-${var.product}-${var.environment}"
  task_family_name          = "ecs-family-${var.product}-${var.component_name}-${var.environment}"
  container_name            = "${var.product}-${var.component_name}-${var.environment}"
  task_definition_role_name = "ecs-tf-${var.product}-${var.component_name}-${var.environment}"
  service_role_name         = "ecs-svc_role-${var.product}-${var.component_name}-${var.environment}"
  log_group_name            = "/ecs/log-${var.product}-${var.component_name}-${var.environment}"
  target_group_name         = "tgr-${var.product}-${var.component_name}-${var.environment}"
  nlb_name                  = "lb-${var.product}-${var.component_name}-${var.environment}"
  alb_name                  = "lb-pub-${var.product}-${var.component_name}-${var.environment}"
  vpc_link_name             = "vpc-link-${var.product}-${var.component_name}-${var.environment}"
  
  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-ecs-svc"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}
