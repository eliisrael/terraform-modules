data "aws_acm_certificate" "cloudfront" {
  domain      = var.certificate_domain
  statuses    = ["ISSUED"]

}

data "aws_cloudfront_cache_policy" "cache_policy" {
  name = "Managed-CachingOptimized"
}