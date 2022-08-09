data "aws_codestarconnections_connection" "pipeline" {
  arn = var.codestar_connection_arn
}