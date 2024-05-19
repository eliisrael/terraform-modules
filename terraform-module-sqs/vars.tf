variable "name" {
  description = "name for sqs (prefix and sufix will be added)"
  type        = string
  default     = ""
}

variable "name_dlq" {
  description = "name for sqs (prefix and sufix will be added)"
  type        = string
  default     = ""
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue"
  default     = false
  type        = bool
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues"
  default     = false
  type        = bool
}

variable "delay_seconds" {
  description = "Visibility timeout in seconds (0-43200 seconds)"
  default     = 0
  type        = number
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue"
  default     = 30
  type        = number
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  default     = 345600
  type        = number
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning"
  default     = 0
  type        = number
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it"
  default     = 256000
  type        = number
}


variable "dlq" {
  description = "Create a dead letter queue"
  default     = false
  type        = bool
}

variable "dlq_existent" {
  description = "Existent dead letter queue"
  default     = true
  type        = bool
}

variable "dlq_name" {
  description = "existent dlq name"
  default     = ""
  type        = string
}
variable "sns_sub" {
  description = "enable sns sub"
  default     = false
  type        = bool
}


variable "sns_arn" {
  description = "sns arn to send messages to"
  default     = ""
  type        = string
}

variable "maximum_receives" {
  description = "maximum_receives for dlq"
  default     = 3
  type        = number
}


