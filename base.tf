module "base" {
  providers = {
    aws = aws.pipeline
  }
  source           = "./modulos/base"
  aws_region       = var.aws_region
  project_name     = var.project_name
  environment      = "base"
  aws_dev_account  = var.aws_dev_account
  aws_prod_account = var.aws_prod_account
  dev_account_role = var.dev_account_role
  prod_account_role = var.prod_account_role
}
