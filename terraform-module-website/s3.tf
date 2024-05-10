resource "aws_s3_bucket" "main" {
  provider = aws.main
  bucket   = local.name
  tags     = local.default_tags
}

resource "aws_s3_bucket_website_configuration" "website" {

  bucket = aws_s3_bucket.main.id
  index_document {
    suffix = var.index_document
  }
}


resource "aws_s3_bucket_policy" "allow_cloud_front" {
  bucket = aws_s3_bucket.main.id
  policy = <<EOF
    {
        "Version": "2008-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "1",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${local.name}/*"
            }
        ]
    }
    EOF
}

