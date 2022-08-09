resource "aws_codepipeline" "pipeline" {
  name     = "${local.nombre}-pipeline"
  role_arn = var.pipeline_role_arn

  artifact_store {
    location = var.pipeline_bucket
    type     = "S3"
  }


  stage {
    name = "${var.aplicacion.nombre}-Source"
    action {
      name             = "${var.aplicacion.nombre}-Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["${var.aplicacion.nombre}-SourceArtifact"]
      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.pipeline.arn
        FullRepositoryId = var.aplicacion.repositorio
        BranchName       = var.aplicacion.branch
      }
    }
  }



  stage {
    name = "${var.aplicacion.nombre}-Build"

    action {
      name             = "${var.aplicacion.nombre}Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.aplicacion.nombre}-SourceArtifact"]
      output_artifacts = ["${var.aplicacion.nombre}-BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }



  stage {
    name = "${var.aplicacion.nombre}-DeployToDev"

    action {
      name            = "${var.aplicacion.nombre}-DeployToDev"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["${var.aplicacion.nombre}-BuildArtifact"]
      version         = "1"
      run_order       = "10"
      role_arn        = var.dev_account_role
      configuration = {
        ClusterName = var.ecs_data.cluster
        ServiceName = var.ecs_data.ecs_service
      }
    }
  }

  # stage {
  #   name = "WaitForApproval"

  #   action {
  #     name      = "ManualApproval"
  #     category  = "Approval"
  #     owner     = "AWS"
  #     provider  = "Manual"
  #     version   = 1
  #     run_order = 10
  #   }
  # }

  # stage {
  #   name = "DeployToProd"

  #   action {
  #     name            = "Deploy"
  #     category        = "Deploy"
  #     owner           = "AWS"
  #     provider        = "CodeDeployToECS"
  #     input_artifacts = ["BuildArtifact"]
  #     version         = "1"
  #     run_order       = "10"

  #     configuration = {
  #       ApplicationName                = aws_codedeploy_app.deploy.name
  #       DeploymentGroupName            = aws_codedeploy_deployment_group.prod.deployment_group_name
  #       TaskDefinitionTemplateArtifact = "BuildArtifact"
  #       TaskDefinitionTemplatePath     = "taskdef.json"
  #       AppSpecTemplateArtifact        = "BuildArtifact"
  #       AppSpecTemplatePath            = "appspec.yaml"
  #     }
  #   }
  # }
}