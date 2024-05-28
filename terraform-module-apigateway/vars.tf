variable "component_name" {
  description = "component name exposed by api gateway"
  type        = string
  default     = ""
}


variable "base_path" {
  default     = ""
  description = "<CUSTOM_DOMAIN>/ => redireciona para este apigw."
}


variable "custom_domain" {
  default     = ""
  description = "custom domain for api gateway"
}

variable "proxy_integration" {
  description = "Generates integration api path /api/v1/external and ignoring path from resources"
  type        = bool
  default     = false
}

variable "resources" {
  type        = list(object({ type = string, end_point = string, version = optional(string), path = string, method = string }))
  default     = []
  description = <<EOF
  List of resources to be called. Ex:. [{"type":"function|container|http|dynamodb|sqs","end_point":"","path":"","method":"ANY"}]
EOF
}

variable "api_key_required" {
  description = "Will need one key to call this apigw?"
  type        = bool
  default     = false
}

variable "vpc-link" {
  description = "VPC Link name"
  type        = string
  default     = ""
}

variable "use_options" {
  description = "Enable OPTIONs on proxy and resources"
  type        = bool
  default     = true
}

variable "binary_media_types" {
  type        = list(string)
  description = "List of binary media types supported by the REST API."
  default     = []
}

variable "content_handling" {
  description = "Content Handling to Binary Type"
  default     = "CONVERT_TO_TEXT"
}


variable "access_control_allow_headers" {
  description = "Do not remove single quotes. Ex: '*'"
  default     = "'*'"
}

variable "access_control_allow_methods" {
  description = "Do not remove single quotes. Ex: 'GET,POST'"
  default     = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
}

variable "access_control_allow_origin" {
  description = "Do not remove single quotes. Ex: '*'n"
  default     = "'*'"
}

variable "access_control_allow_credentials" {
  description = "Do not remove single quotes. Ex: 'true'"
  default     = "'true'"
}

variable "cache_enabled" {
  description = "Specifies whether a cache cluster is enabled"
  type        = bool
  default     = false
}

variable "headers_custom" {
  description = "Custom request query string parameters and headers that should be passed to the backend responder, if needed."
  default     = null
}

variable "apis_versions" {
  default     = ["v1"]
  type        = list(string)
  description = "Generates integration api path /api/v*/external"
}

variable "base_path_enabled" {
  default     = false
  type        = bool
  description = "enable base path mapping"
}