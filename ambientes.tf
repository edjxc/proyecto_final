
module "dev" {
  providers = {
    aws = aws.dev
  }
  source               = "./modulos/ambientes"
  region               = var.aws_region
  environment          = "dev"
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.region_az_list
  project_name         = var.project_name
  cluster_min_size     = var.cluster_min_size
  cluster_max_size     = var.cluster_max_size
  cluster_size         = var.cluster_size
  app1_ecs_task        = var.app1_ecs_task
  app2_ecs_task        = var.app2_ecs_task
  aplicacion = {
    nombre      = "App1"
  }
  ecr_repository       = module.base.ecr_repository
  assume_account_role  = var.dev_account_role
}

# module "infra-pro" {
#   providers = {
#     aws = aws.pro
#   }
#   source               = "./modulos/ambientes"
#   region               = var.aws_region
#   environment          = "pro"
#   vpc_cidr             = var.vpc_cidr
#   public_subnets_cidr  = var.public_subnets_cidr
#   private_subnets_cidr = var.private_subnets_cidr
#   availability_zones   = local.region_az_list
#   project_name         = var.project_name
#   prod_ecs_task    = var.prod_ecs_task
#   cluster_min_size = var.cluster_min_size
#   cluster_max_size = var.cluster_max_size
#   cluster_size     = var.cluster_size
# }