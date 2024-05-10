variable "component_name" {
  description = "component name"
  type        = string
  default     = ""
}

variable "dynamic_origin_s3" {
  description = "Configuration for the s3 origin config to be used in dynamic block"
  type        = any
  default     = []
}

variable "dynamic_ordered_cache_behavior" {
  description = "Configuration for the ordered cache behavior to be used in dynamic block"
  type        = any
  default     = []
}

variable "index_document" {
  type        = string
  description = "HTML to show at root"
  default     = "index.html"
}



variable "alias" {
  type        = string
  description = "cname for distribution"
  default     = ""
}