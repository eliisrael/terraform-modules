variable "component_name" {
  description = "component name for code build project"
  type        = string
  default     = ""
}

variable "source_provider" {
  description = "source code provider"
  type        = string
  default     = ""
}

variable "repository_name" {
  description = "repository name"
  type        = string
  default     = ""
}

variable "build_spec" {
  description = "job build spec file location"
  type        = string
  default     = ""
}

variable "image_repo_name" {
  description = "image repo name"
  type        = string
  default     = ""
}

variable "source_version" {
  description = "branch for code checkout"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
    type = list
    description = "policies for codebuild definition role"
    default = []
}

variable "code_pipeline_managed_policy_arns" {
    type = list
    description = "policies for codepipeline definition role"
    default = []
}

variable "build_worker_image" {
    type = string
    description = "image for codebuild worker"
    default = ""
}


variable "create_codebuild" {
    type = bool
    description = "create codebuild project flag"
    default = false
}

variable "website_pipeline" {
    type = bool
    description = "create website pipeline flag"
    default = false
}

variable "ecs_multiple_services" {
    type = bool
    description = "create ecs multiple services pipeline flag"
    default = false
}

variable "ecs_service" {
    type = bool
    description = "create ecs service pipeline flag"
    default = false
}


variable "codepipeline_repo_name" {
    type = string
    description = "repository name for codepipeline"
    default = ""
}

variable "github_connection_name" {
    type = string
    description = "connection name for github"
    default = ""
}

variable "cluster_name" {
    type = string
    description = "ECS cluster name"
    default = ""
}

variable "service_name" {
    type = string
    description = "Deploy service name"
    default = ""
}


variable "service_name_consumer" {
    type = string
    description = "Deploy service name for consumer"
    default = ""
}

variable "service_image_definition_file" {
    type = string
    description = "file for ecr image definition"
    default = ""
}


variable "service_consumer_image_definition_file" {
    type = string
    description = "file for ecr image definition for consumer"
    default = ""
}


variable "included_branches" {
    type = list
    description = "branches included for trigger pipeline"
    default = []
}

variable "s3_website_bucket" {
    type = string
    description = "bucket for s3 website"
    default = ""
}


