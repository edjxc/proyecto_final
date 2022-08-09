data "aws_iam_policy_document" "ecs-tasks" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "task_role" {
  name               = "${local.nombre}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs-tasks.json
  tags = {
    Name        = "${local.nombre}-task-role"
    Environment = var.environment
  }

}

data "aws_iam_policy" "aws-task-role-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-tasks-role-policy-att" {
  role       = aws_iam_role.task_role.name
  policy_arn = data.aws_iam_policy.aws-task-role-policy.arn
}

data "aws_iam_role" "AWSServiceRoleForECS" {
  name = "AWSServiceRoleForECS"
}