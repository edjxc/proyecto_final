resource "aws_s3_bucket" "pipeline" {
  bucket_prefix = "${local.nombre}-pipeline"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "bucketacl" {
  bucket = aws_s3_bucket.pipeline.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "cross_account" {
  bucket = aws_s3_bucket.pipeline.id
  policy = data.aws_iam_policy_document.cross_account.json
}

data "aws_iam_policy_document" "cross_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.aws_dev_account, var.aws_prod_account]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.pipeline.arn,
      "${aws_s3_bucket.pipeline.arn}/*",
    ]
  }
}