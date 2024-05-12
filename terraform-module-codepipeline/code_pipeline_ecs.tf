resource "aws_codepipeline" "ecs_service" {
  count         = var.ecs_service ? 1 : 0
  name          = local.pipelinet_name
  role_arn      = aws_iam_role.codepipeline_role.arn
  pipeline_type = "V2"
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"


  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.github_svc.arn
        FullRepositoryId = var.codepipeline_repo_name
        BranchName       = var.source_version
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.project[0].name
        EnvironmentVariables = jsonencode([])
      }


    }

  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ClusterName = var.cluster_name
        ServiceName = var.service_name
        FileName    = var.service_image_definition_file
      }
    }


  }
  trigger {

    provider_type = "CodeStarSourceConnection"
    git_configuration {
      source_action_name = "Source"
      push {
        branches {
          includes = var.included_branches
        }
      }
    }

  }

  lifecycle {
    ignore_changes = [stage[1].action[0].configuration["EnvironmentVariables"]]
  }

}

data "aws_codestarconnections_connection" "github_svc" {
  name = var.github_connection_name

}
