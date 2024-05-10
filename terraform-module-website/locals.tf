
locals {

  name = "website-${var.product}-${var.component_name}-${var.environment}"

  bucket_cloudfront_access_policy = [{
    sid = "PolicyForCloudFrontPrivateContent"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "arn:aws:s3:::${local.name}/*",
      "arn:aws:s3:::${local.name}",
    ]

    principals = [{
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }]
  }]

  bucket_policies = local.bucket_cloudfront_access_policy

  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-website"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}
