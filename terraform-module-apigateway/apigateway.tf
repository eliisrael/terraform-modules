resource "aws_api_gateway_rest_api" "this" {
  name        = local.api_name
  description = "Created by Terraform"


  endpoint_configuration {
    types = ["REGIONAL"]

  }

  lifecycle {
    ignore_changes = [body]
  }

}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  variables = {
    deployed_at = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.this,
    aws_api_gateway_method.path_external_options,
    aws_api_gateway_integration.this,
    aws_api_gateway_integration.proxy,
    aws_api_gateway_integration.root

  ]

}


resource "aws_api_gateway_stage" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = var.environment

  deployment_id = aws_api_gateway_deployment.this.id


  depends_on = [aws_api_gateway_deployment.this]
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count = var.base_path_enabled ? 1 : 0

  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = var.environment
  domain_name = var.custom_domain
  base_path   = var.base_path != "" ? var.base_path : null

  depends_on = [aws_api_gateway_stage.this]
}

