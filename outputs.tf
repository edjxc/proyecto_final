output "ecr_repository" {
  value = module.base.ecr_repository.*
}

output "build_role_arn" {
  value = module.base.build_role_arn
}

output "pipeline_role_arn" {
  value = module.base.pipeline_role_arn
}

output "pipeline_bucket" {
  value = module.base.pipeline_bucket
}

output "vpc_id" {
  value = module.dev.vpc_id
}

output "public_subnets" {
  value = module.dev.public_subnets
}

output "private_subnets" {
  value = module.dev.private_subnets
}

output "default_security_group" {
  value = module.dev.default_security_group
}

output "security_groups" {
  value = module.dev.security_groups
}

output "public_route_table" {
  value = module.dev.public_route_table
}

output "ecs_data" {
  value = module.dev.ecs_data
}

output "app1_task_definition" {
  value = module.dev.app1_task_definition
}

output "app2_task_definition" {
  value = module.dev.app2_task_definition
}

output "load_balancer" {
  value = module.dev.load_balancer
}
