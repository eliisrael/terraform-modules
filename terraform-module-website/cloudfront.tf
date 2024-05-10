

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {

  comment = local.name
}

resource "aws_cloudfront_distribution" "main" {

  http_version        = "http2"
  enabled             = true
  default_root_object = var.index_document
  aliases             = [var.alias]

  origin {

    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id   = "S3-${local.name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  dynamic "origin" {
    for_each = [for i in var.dynamic_origin_s3 : {
      name = i.domain_name
      id   = i.origin_id
      path = lookup(i, "origin_path", "")
    }]
    content {
      domain_name = "${origin.value.name}.s3.${var.region}.amazonaws.com"
      origin_id   = "S3-${origin.value.id}"
      origin_path = origin.value.path

      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
      }
    }
  }


  default_cache_behavior {
    target_origin_id = "S3-${local.name}"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true

    cache_policy_id = data.aws_cloudfront_cache_policy.cache_policy.id

    viewer_protocol_policy = "redirect-to-https"

  }

  dynamic "ordered_cache_behavior" {
    for_each = var.dynamic_ordered_cache_behavior
    iterator = ordered
    content {
      path_pattern           = "/${ordered.value.path_pattern}"
      target_origin_id       = ordered.value.type != "S3" ? "Custom-${ordered.value.target_origin_id}" : "S3-${ordered.value.target_origin_id}"
      allowed_methods        = ["GET", "HEAD", "OPTIONS"]
      cached_methods         = ["GET", "HEAD"]
      compress               = true
      viewer_protocol_policy = "redirect-to-https"
      min_ttl                = lookup(ordered.value, "min_ttl", 0)
      default_ttl            = lookup(ordered.value, "default_ttl", 300)
      max_ttl                = lookup(ordered.value, "max_ttl", 1200)

      forwarded_values {
        query_string = false

        cookies {
          forward = "none"
        }

      }
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.cloudfront.arn
    ssl_support_method  = "sni-only"

  }
  //  is_ipv6_enabled (Optional) - Whether the IPv6 is enabled for the distribution.
}


