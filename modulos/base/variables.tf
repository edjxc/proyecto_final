variable "project_name" {
  description = "Nombre del proyecto"
}

variable "environment" {
  description = "Ambiente [prod,qa,dev]"
}

variable "aws_dev_account" {}
variable "aws_prod_account" {}
variable "aws_region" {}
variable "prod_account_role" {}
variable "dev_account_role" {}