variable "aws_region" {
  description = "The AWS Region ID"
  default     = "us-east-1"
}

variable "account_id" {
  description = "The AWS Account ID"
}

#variable "mfa_token" {
#  description = "Ingrese un token de autenticación MFA para la cuenta actual"
#}

variable "instance_type" {
  default = "t2.micro"
}
variable "creator" {}
variable "provisiontool" {}
variable "project_name" {}
variable "aws_prod_account" {}
variable "aws_dev_account" {}