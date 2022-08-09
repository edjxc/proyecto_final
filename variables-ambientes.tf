variable "environment" {
  description = "Ambiente [prod,qa,dev]"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "Rango CIDR de la VPC"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "Lista de Rangos CIDR de las subredes públicas [cidr1, cidr2, etc]"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "Lista de Rangos CIDR de las subredes privadas"
}

variable "dev_account_role" {}
variable "prod_account_role" {}

variable "cluster_min_size" {}
variable "cluster_max_size" {}
variable "cluster_size" {}
variable "deployment_strategy" {}
variable "app1_ecs_task" {}
variable "app2_ecs_task" {}