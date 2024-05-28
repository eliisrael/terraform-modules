data "aws_acm_certificate" "product" {
  domain   = var.certificate_domain
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "zone" {
  name         = var.hosted_zone
}
