project_name         = "final"
aws_region           = "us-east-1"
account_id           = "117132815424"
aws_dev_account      = "797796841888"
dev_account_role     = "arn:aws:iam::797796841888:role/MasterAccount_Admin_AccessRole"
prod_account_role    = "arn:aws:iam::254183230632:role/MasterAccount_Admin_AccessRole"
aws_prod_account     = "254183230632"
instance_type        = "t2.micro"
creator              = "Eric"
provisiontool        = "Terraform"
vpc_cidr             = "10.1.0.0/16"
private_subnets_cidr = ["10.1.10.0/24", "10.1.11.0/24"]
public_subnets_cidr  = ["10.1.20.0/24", "10.1.21.0/24"]


cluster_min_size    = 1
cluster_max_size    = 1
cluster_size        = 1
deployment_strategy = "CodeDeployDefault.ECSAllAtOnce"
                      # CodeDeployDefault.ECSAllAtOnce
                      # CodeDeployDefault.ECSLinear10PercentEvery1Minutes
                      # CodeDeployDefault.ECSLinear10PercentEvery3Minutes
                      # CodeDeployDefault.ECSCanary10Percent5Minutes
                      # CodeDeployDefault.ECSCanary10Percent15Minutes
app1_ecs_task = {
  name               = "%appname%-app1"
  container_name     = "app"
  memory = 512
  cpu    = 256
  log_group          = "/ecs/%appname%/app1/app"
  port               = 8080
}
app2_ecs_task = {
  name               = "%appname%-app2"
  container_name     = "app"
  memory = 512
  cpu    = 256
  log_group          = "/ecs/%appname%/app2/app"
  port               = 8080
}