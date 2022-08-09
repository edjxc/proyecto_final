module "pipeline-app1" {
  providers = {
    aws = aws.pipeline
  }
  source       = "./modulos/pipeline"
  aws_region   = var.aws_region
  project_name = var.project_name
  environment  = "base"
  aplicacion = {
    nombre      = "App1"
    repositorio = "edjxc/final_app1"
    branch      = "master"
  }
  codestar_connection_arn = "arn:aws:codestar-connections:us-east-1:117132815424:connection/bf99ce7a-d78f-4072-8165-1ede047d7ca9"
  build_role_arn          = module.base.build_role_arn
  pipeline_role_arn       = module.base.pipeline_role_arn
  pipeline_bucket         = module.base.pipeline_bucket
  ecr_repository          = module.base.ecr_repository
  ecs_data                = {
     cluster     = module.dev.ecs_data.cluster
     ecs_service = module.dev.ecs_data.app1_service
  }
  dev_load_balancer       = module.dev.load_balancer
  dev_task_definition     = module.dev.app1_task_definition
  deployment_strategy     = var.deployment_strategy
  dev_account_role        = var.dev_account_role
  prod_account_role       = var.prod_account_role
}
