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

variable "component_name" {
  description = "Database component name"
  type        = string
  default     = ""
}


variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = ""
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = "1"
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = ""
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = ""
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t2.micro"
}

variable "subnet_group_name" {
  description = "subnet group name"
  type        = string
  default     = ""
}

variable "security_group_cidr" {
  description = "database security group netwotk cidr"
  type        = list
  default     = []
}


variable "publicly_accessible" {
  description = "access tier for database"
  type        = bool
  default     = false
}


variable "create_postgres_db_parameter_group" {
  description = "Determines whether to create a custom parameter group for the RDS Postgres instance"
  type        = bool
  default     = false
}






