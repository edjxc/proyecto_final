resource "aws_security_group" "sg-alb" {
  name        = "${var.environment}-${var.project_name}-alb"
  description = "Permitir trafico desde internet"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Desde Internet"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8080"
    to_port     = "8081"
  }

  ingress {
    description = "Desde Target Group 1"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8080"
    to_port     = "8080"
  }

  ingress {
    description = "Desde Target Group 2"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8081"
    to_port     = "8081"
  }

  egress {
    description = "Salida a Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.project_name}-sg-alb"
    Environment = var.environment
  }

}


resource "aws_lb" "this" {
  name               = "${var.environment}-${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  tags = {
    Name        = "${var.environment}-${var.project_name}-alb"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http_app1" {
  load_balancer_arn = aws_lb.this.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_app1.arn
  }
}

resource "aws_lb_listener" "http_app2" {
  load_balancer_arn = aws_lb.this.arn
  port              = "8081"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_app2.arn
  }

}

resource "aws_lb_target_group" "tg_app1" {
  name                 = "${var.environment}-${var.project_name}-app1"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc.id
  deregistration_delay = 60
  target_type          = "ip"
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 25
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_app2" {
  name                 = "${var.environment}-${var.project_name}-app2"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc.id
  deregistration_delay = 60
  target_type          = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 25
    interval            = 30
    matcher             = "200"
  }
}