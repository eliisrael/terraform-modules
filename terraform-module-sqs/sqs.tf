resource "aws_sqs_queue" "terraform_queue_no_dlq" {
  count                       = var.dlq ? 0 : var.dlq_existent ? 0 : 1
  name                        = var.name
  message_retention_seconds   = var.message_retention_seconds
  max_message_size            = var.max_message_size
  delay_seconds               = var.delay_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  visibility_timeout_seconds  = var.visibility_timeout_seconds

  tags = merge(
    local.default_tags,
    {
      Name = var.name

    },
  )
}

resource "aws_sqs_queue" "terraform_queue" {
  count                       = var.dlq ? 1 : (var.dlq_existent ? 1 : 0)
  name                        = var.name
  message_retention_seconds   = var.message_retention_seconds
  max_message_size            = var.max_message_size
  delay_seconds               = var.delay_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  visibility_timeout_seconds  = var.visibility_timeout_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = var.dlq ? aws_sqs_queue.terraform_queue_deadletter[0].arn : local.dlq_arn
    maxReceiveCount     = var.maximum_receives
  })

  tags = merge(
    local.default_tags,
    {
      Name = var.name
    },
  )
}

resource "aws_sqs_queue" "terraform_queue_deadletter" {
  count = var.dlq ? 1 : 0
  name  = var.dlq_name

  tags = merge(
    local.default_tags,
    {
      Name = var.dlq_name
    },
  )
}

resource "aws_sqs_queue_redrive_allow_policy" "terraform_queue_redrive_allow_policy" {
  count     = var.dlq ? 1 : 0
  queue_url = aws_sqs_queue.terraform_queue_deadletter[0].url

  redrive_allow_policy = jsonencode({
    redrivePermission = "allowAll",
  })
}

resource "aws_sns_topic_subscription" "sns_to_sqs" {
  count     = var.sns_sub ? 1 : 0
  topic_arn = var.sns_arn
  protocol  = "sqs"
  endpoint  = var.dlq ? aws_sqs_queue.terraform_queue[0].arn : var.dlq_existent ? aws_sqs_queue.terraform_queue[0].arn : aws_sqs_queue.terraform_queue_no_dlq[0].arn
}
