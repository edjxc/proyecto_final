output "ecr_repository" {
  value = {
    arn = aws_ecr_repository.repo.arn
    url = aws_ecr_repository.repo.repository_url
  }
}

output "build_role_arn" {
  value = aws_iam_role.build_role.arn
}

output "pipeline_role_arn" {
  value = aws_iam_role.pipeline_role.arn
}

output "pipeline_bucket" {
  value = aws_s3_bucket.pipeline.id
}