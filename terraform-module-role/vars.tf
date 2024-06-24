variable "name" {
  description = "name for sqs (prefix and sufix will be added)"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
    type = list
    description = "policies for task definition role"
    default = []
}

variable "assume_role_policy" {
  description = "jsonecoded assume role policy"
  type        = string
  default     = ""
}