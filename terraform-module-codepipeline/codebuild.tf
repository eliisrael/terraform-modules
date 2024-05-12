resource "aws_codebuild_project" "project" {
  count          = var.create_codebuild ? 1 : 0
  name           = local.project_name
  description    = local.project_name
  build_timeout  = 5
  queued_timeout = 5

  service_role = aws_iam_role.codebuild_role[0].arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.build_worker_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id

    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"

    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.image_repo_name

    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "codebuild/${local.project_name}"

    }


  }


  source {
    type            = var.source_provider
    location        = var.repository_name
    buildspec       = var.build_spec
    git_clone_depth = 1
  }
  source_version = var.source_version
  tags = merge(
    local.default_tags,
    {
      Name = local.project_name

    }
  )
}
