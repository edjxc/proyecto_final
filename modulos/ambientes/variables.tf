variable "project_name" {
  description = "Nombre del proyecto"
}

variable "environment" {
  description = "Ambiente [prod,qa,dev]"
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

variable "region" {
  description = "Region donde se debe crear la maquina bastion"
}

variable "availability_zones" {
  type        = list(any)
  description = "Zona de disponibilidad donde se deben crear los recursos"
}
variable "aplicacion" {}
variable "ecr_repository" {}
variable "cluster_min_size" {}
variable "cluster_max_size" {}
variable "cluster_size" {}
variable "app1_ecs_task" {
  default = {
    name               = "%appname%-app1"
    container_name     = "app"
    memory_reservation = 64
    log_group          = "/ecs/%appname%/app1/app"
    port               = 80
  }
}
variable "app2_ecs_task" {
  default = {
    name               = "%appname%-app2"
    container_name     = "app"
    memory_reservation = 64
    log_group          = "/ecs/%appname%/app2/app"
    port               = 80
  }
}
variable "assume_account_role" {}