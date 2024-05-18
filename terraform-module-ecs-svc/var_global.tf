variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = ""
}

variable "product" {
  description = "Product"
  type        = string
  default     = ""
}

variable "created_by" {
  description = "created_by"
  type        = string
  default     = "undefined"
}

variable "created_at" {
  description = "created_at"
  type        = string
  default     = "undefined"
}

variable "account" {
  description = "Account name"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "Account Id"
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "Product vpc name"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "Product vpc id"
  type        = string
  default     = ""
}

variable "private_subnets" {
  description = "Product private subnets"
  type        = list(any)
  default     = []
}

variable "public_subnets" {
  description = "Product public subnets"
  type        = list(any)
  default     = []
}

