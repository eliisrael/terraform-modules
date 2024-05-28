resource "aws_api_gateway_domain_name" "custom_domain" {
  regional_certificate_arn = data.aws_acm_certificate.product.arn
  domain_name     = var.custom_domain

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
