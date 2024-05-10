data "aws_route53_zone" "main" {
 
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "web" {
  provider = aws.main
  zone_id  = data.aws_route53_zone.main.zone_id
  name     = var.alias
  type     = "A"
 
alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
  }
}

