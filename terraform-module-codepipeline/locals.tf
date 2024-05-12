locals {

  project_name       = "codebuild-${var.component_name}-${var.product}-${var.environment}"
  role_name          = "codebuild-role-${var.component_name}-${var.product}-${var.environment}"
  pipelinet_name     = "pipeline-${var.component_name}-${var.product}-${var.environment}"
  pipeline_role_name = "pipeline-role-${var.component_name}-${var.product}-${var.environment}"

  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-codepipeline"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}
