resource "aws_codepipeline" "website" {
  count         = var.website_pipeline ? 1 : 0
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
        ConnectionArn    = data.aws_codestarconnections_connection.github_website.arn
        FullRepositoryId = var.codepipeline_repo_name
        BranchName       = var.source_version
      }
    }
  }


  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        BucketName = var.s3_website_bucket
        Extract    = true
      }
    }


  }

  stage {
    name = "CleanCache"

    action {
      name             = "CleanCache"
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
      ignore_changes = [stage[2].action[0].configuration["EnvironmentVariables"]]
    }

}

data "aws_codestarconnections_connection" "github_website" {
  name = var.github_connection_name

}
