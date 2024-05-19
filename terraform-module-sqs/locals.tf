locals {
dlq_arn = "arn:aws:sqs:${var.region}:${var.account_id}:${var.dlq_name}"
dlq_url = "https://sqs.${var.region}.amazonaws.com/${var.account_id}/${var.dlq_name}"



  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-sqs"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}