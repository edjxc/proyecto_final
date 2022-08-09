variable "project_name" {
  description = "Nombre del proyecto"
}

variable "environment" {
  description = "Ambiente [prod,qa,dev]"
}

# variable "aws_dev_account" {}
# variable "aws_prod_account" {}
variable "aws_region" {}
variable "codestar_connection_arn" {}
variable "build_role_arn" {}
variable "pipeline_role_arn" {}
variable "pipeline_bucket" {}
variable "aplicacion" {}

variable "ecr_repository" {}
variable "ecs_data" {}
variable "dev_load_balancer" {}
variable "dev_task_definition" {}
#variable "prod_task_definition" {}
variable "deployment_strategy" {}
variable  "dev_account_role" {}
variable  "prod_account_role" {}