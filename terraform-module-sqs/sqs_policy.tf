
resource "aws_sqs_queue_policy" "sqs_access_policy" {
  count     = var.sns_sub ? 1 : 0
  queue_url = var.dlq ? aws_sqs_queue.terraform_queue[0].url : var.dlq_existent ? aws_sqs_queue.terraform_queue[0].url : aws_sqs_queue.terraform_queue_no_dlq[0].url
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "__default_policy_ID",
    Statement = [
      {
        Sid    = "__owner_statement",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        },
        Action   = "SQS:*",
        Resource = var.dlq ? aws_sqs_queue.terraform_queue[0].arn : var.dlq_existent ? aws_sqs_queue.terraform_queue[0].arn : aws_sqs_queue.terraform_queue_no_dlq[0].arn
      },
      {
        Sid    = "topic-subscription-${var.sns_arn}"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "SQS:SendMessage"
        Resource = var.dlq ? aws_sqs_queue.terraform_queue[0].arn : var.dlq_existent ? aws_sqs_queue.terraform_queue[0].arn : aws_sqs_queue.terraform_queue_no_dlq[0].arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = var.sns_arn
          }
        }
      }
    ]
  })
}


