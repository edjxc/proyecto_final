# CodeBuild Role
data "aws_iam_policy_document" "codebuild-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "build_role" {
  name               = "${local.nombre}-codebuildServiceRole"
  assume_role_policy = data.aws_iam_policy_document.codebuild-assume-role-policy.json
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryPowerUser" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "ecr_poweruser_attach" {
  role       = aws_iam_role.build_role.name
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryPowerUser.arn
}

resource "aws_iam_role_policy" "base_policy" {
  name   = "base_policy"
  role   = aws_iam_role.build_role.name
  policy = data.aws_iam_policy_document.base_policy.json
}

data "aws_iam_policy_document" "base_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:PutObject*"
    ]
    resources = [
      "${aws_s3_bucket.pipeline.arn}",
      "${aws_s3_bucket.pipeline.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "codepipeline-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "pipeline_role" {
  name               = "${local.nombre}-codepipelineServiceRole"
  assume_role_policy = data.aws_iam_policy_document.codepipeline-assume-role-policy.json
}

resource "aws_iam_role_policy" "pipeline_base_policy" {
  name   = "pipeline_base_policy"
  role   = aws_iam_role.pipeline_role.name
  policy = data.aws_iam_policy_document.pipeline_base_policy.json
}

data "aws_iam_policy_document" "pipeline_base_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [var.dev_account_role,var.prod_account_role]
    effect    = "Allow"
  }

  statement {
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    effect = "Allow"
    actions = [
      "devicefarm:ListProjects",
      "devicefarm:ListDevicePools",
      "devicefarm:GetRun",
      "devicefarm:GetUpload",
      "devicefarm:CreateUpload",
      "devicefarm:ScheduleRun"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "servicecatalog:ListProvisioningArtifacts",
      "servicecatalog:CreateProvisioningArtifact",
      "servicecatalog:DescribeProvisioningArtifact",
      "servicecatalog:DeleteProvisioningArtifact",
      "servicecatalog:UpdateProduct"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudformation:ValidateTemplate"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:DescribeImages",
      "codestar-connections:UseConnection"
    ]
    resources = ["*"]
  }

}

#--------------------------------------------------------------
# CodeDeploy Role
#--------------------------------------------------------------
data "aws_iam_policy_document" "codedeploy-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "deploy_role" {
  name               = "${local.nombre}-codedeployServiceRole"
  assume_role_policy = data.aws_iam_policy_document.codedeploy-assume-role-policy.json
}

data "aws_iam_policy" "AWSCodeDeployRoleForECS" {
  arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy_attachment" "ecs_servicerole_attach" {
  role       = aws_iam_role.deploy_role.name
  policy_arn = data.aws_iam_policy.AWSCodeDeployRoleForECS.arn
}