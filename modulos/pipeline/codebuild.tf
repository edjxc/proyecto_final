resource "aws_codebuild_project" "build" {
  name         = "${local.nombre}-build"
  service_role = var.build_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "ECR_URI"
      value = var.ecr_repository.url
    }


  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec.yml")
  }
}