resource "aws_ecr_repository" "repo" {
  name = "${var.environment}-${var.project_name}-repo"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "task-def" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_role.arn
  #task_role_arn            = aws_iam_role.task_role.arn
  container_definitions = jsonencode([{
   name        = "${var.environment}-${var.project_name}-cluster"
   image       = "${var.container_image}:latest"
   essential   = true
   environment = var.container_environment
   portMappings = [{
     protocol      = "tcp"
     containerPort = var.container_port
     hostPort      = var.container_port
   }]
}