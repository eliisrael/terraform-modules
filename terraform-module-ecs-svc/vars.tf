variable "component_name" {
  description = "Product Component Name"
  type        = string
  default     = ""
}

variable "container_port" {
  description = "Product Component Name"
  type        = number
  default     = 80
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = ""
}

variable "cpu" {
  description = "CPU for task definition"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memory for task definition"
  type        = number
  default     = 2048
}

variable "nlb_prefix" {
  description = "Prefix for default nlb"
  type        = string
  default     = ""
}

variable "vpc_link_prefix" {
  description = "Prefix for default api gateway vpc link"
  type        = string
  default     = ""
}

variable "create_api_exposition" {
    type = bool
    description = "expose service with nlb"
    default = false
}

variable "create_api_exposition_public" {
    type = bool
    description = "expose service with public alb"
    default = false
}

variable "target_group_port" {
    type = number
    description = "target group port"
    default = 1
}

variable "cluster_name" {
    type = string
    description = "ecs cluster name"
    default = ""
}

variable "image" {
    type = string
    description = "image uri"
    default = ""
}

variable "image_repo_name" {
    type = string
    description = "image repo name"
    default = ""
}



variable "managed_policy_arns" {
    type = list
    description = "policies for task definition role"
    default = []
}

variable "target_group_protocol" {
    type = string
    description = "protocol for service target group"
    default = "TCP"
}

variable "certificate_domain" {
    type = string
    description = "certificate domain"
    default = ""
}

