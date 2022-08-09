resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.nombre
}

data "template_file" "container_definition_app1" {
  template = "${file("${path.module}/container-definition.json")}"

  vars = {
    container_name     = var.app1_ecs_task.container_name
    image_repository   = var.ecr_repository.url
    image_tag          = "latest"
    memory_reservation = var.app1_ecs_task.memory
    port               = var.app1_ecs_task.port
    log_group          = replace(var.app1_ecs_task.log_group, "%appname%", local.nombre)
    region             = var.region
  }
}

data "template_file" "container_definition_app2" {
  template = file("${path.module}/container-definition.json")

  vars = {
    container_name     = var.app2_ecs_task.container_name
    image_repository   = var.ecr_repository.url
    image_tag          = "latest"
    memory_reservation = var.app2_ecs_task.memory
    port               = var.app2_ecs_task.port
    log_group          = replace(var.app2_ecs_task.log_group, "%appname%", local.nombre)
    region             = var.region
  }
}

resource "aws_ecs_task_definition" "task_app1" {
  network_mode             = "awsvpc"
  family                   = replace(var.app1_ecs_task.name, "%appname%", local.nombre)
  container_definitions    = data.template_file.container_definition_app1.rendered
  execution_role_arn       = aws_iam_role.task_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.app2_ecs_task.cpu
  memory                   = var.app2_ecs_task.memory

}

resource "aws_ecs_task_definition" "task_app2" {
  network_mode             = "awsvpc"
  family                   = replace(var.app2_ecs_task.name, "%appname%", local.nombre)
  container_definitions    = data.template_file.container_definition_app2.rendered
  execution_role_arn       = aws_iam_role.task_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.app2_ecs_task.cpu
  memory                   = var.app2_ecs_task.memory
}

resource "aws_cloudwatch_log_group" "logs_app1" {
  name = replace(var.app1_ecs_task.log_group, "%appname%", local.nombre)
}

resource "aws_cloudwatch_log_group" "logs_app2" {
  name = replace(var.app2_ecs_task.log_group, "%appname%", local.nombre)
}

resource "aws_ecs_service" "service_app1" {
  name            = "${local.nombre}-app1"
  cluster         = aws_ecs_cluster.ecs_cluster.name
  task_definition = aws_ecs_task_definition.task_app1.arn
  desired_count   = 1
  #iam_role        = data.aws_iam_role.AWSServiceRoleForECS.arn
  depends_on      = [aws_lb_listener.http_app1, aws_cloudwatch_log_group.logs_app1]

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  network_configuration  {
    subnets   = aws_subnet.public_subnet[*].id
    security_groups = [aws_security_group.sg-alb.id]
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.tg_app1.arn
    container_name   = var.app1_ecs_task.container_name
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}

resource "aws_ecs_service" "service_app2" {
  name            = "${local.nombre}-app2"
  cluster         = aws_ecs_cluster.ecs_cluster.name
  task_definition = aws_ecs_task_definition.task_app2.arn
  desired_count   = 1
  #iam_role        = data.aws_iam_role.AWSServiceRoleForECS.arn
  depends_on      = [aws_lb_listener.http_app2, aws_cloudwatch_log_group.logs_app2]

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  network_configuration  {
    subnets   = aws_subnet.public_subnet[*].id
    security_groups = [aws_security_group.sg-alb.id]
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_app2.arn
    container_name   = var.app2_ecs_task.container_name
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition, load_balancer]
  }
}