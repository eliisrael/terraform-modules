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
  description = "VPC Name"
  type        = string
  default     = ""
}

variable "vpc_name_suffix" {
  description = "VPC Suffic Ex name: vpc-{environemnt}-{vpc_name_suffix}"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "Base IP Ranges for this VPC"
  type        = string
  default     = ""
}

variable "enable_dns_hostnames" {
  description = "Base IP Ranges for this VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Base IP Ranges for this VPC"
  type        = bool
  default     = true
}

variable "azs" {
  description = "AZs that will be used"
  type        = list
  default     = ["a", "b", "c"]
}

variable "azs_names" {
  description = "AZs names"
  type        = list
  default     = ["az1a", "az2b", "az3c"]
}

variable "public_cidrs" {
  description = "CIDRs for private subnets"
  type        = list
  default     = []
}

variable "private_cidrs" {
  description = "CIDRs for private subnets"
  type        = list
  default     = []
}

variable "isolated_cidrs" {
  description = "CIDRs for isolated subnets"
  type        = list
  default     = []
}

variable "internet_gw" {
  description = "Internet Gateway Name"
  type        = string
  default     = ""
}

variable "eip_base_name" {
  description = "Elastic IP Base Name"
  type        = string
  default     = ""
}

variable "nat_gw_base_name" {
  description = "Nat Gateway Base Name"
  type        = string
  default     = ""
}

variable "public_route_table" {
  description = "Public route table name"
  type        = string
  default     = ""
}

variable "private_route_table_base_name" {
  description = "Public route table base name"
  type        = string
  default     = ""
}

variable "hosted_zone" {
  description = "Route53 hosted zone"
  type        = string
  default     = ""
}