resource "aws_ecr_repository" "repo" {
  name                 = "${local.nombre}-repo"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.repo.name
  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        "Sid" : "AllowCrossAccounts",
        "Effect" : "Allow",
        "Principal" : {
          AWS = [
            "arn:aws:iam::${var.aws_dev_account}:root",
            "arn:aws:iam::${var.aws_prod_account}:root"
          ]
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  })

}
