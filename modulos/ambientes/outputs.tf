output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = ["${aws_subnet.public_subnet.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

output "default_security_group" {
  value = aws_security_group.default.id
}

output "security_groups" {
  value = ["${aws_security_group.default.id}"]
}

output "public_route_table" {
  value = aws_route_table.public.id
}

output "ecs_data" {
  value = {
    cluster      = aws_ecs_cluster.ecs_cluster.name
    app1_service = aws_ecs_service.service_app1.name
    app2_service = aws_ecs_service.service_app2.name
  }
}

output "app1_task_definition" {
  value = {
    name               = replace(var.app1_ecs_task.name, "%appname%", local.nombre)
    role               = aws_iam_role.task_role.arn
    container_name     = var.app1_ecs_task.container_name
    memory_reservation = var.app1_ecs_task.memory
    port               = var.app1_ecs_task.port
    log_group          = replace(var.app1_ecs_task.log_group, "%appname%", local.nombre)
  }
}

output "app2_task_definition" {
  value = {
    name               = replace(var.app2_ecs_task.name, "%appname%", local.nombre)
    role               = aws_iam_role.task_role.arn
    container_name     = var.app2_ecs_task.container_name
    memory_reservation = var.app2_ecs_task.memory
    port               = var.app2_ecs_task.port
    log_group          = replace(var.app1_ecs_task.log_group, "%appname%", local.nombre)
  }
}

output "load_balancer" {
  value = {
    app1_listener = aws_lb_listener.http_app1.arn
    app2listener  = aws_lb_listener.http_app2.arn
    targetgroup_1 = aws_lb_target_group.tg_app1.name
    targetgroup_2 = aws_lb_target_group.tg_app2.name
    dns_name      = aws_lb.this.dns_name
  }
}
