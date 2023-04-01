resource "aws_lb" "alb" {
  name               = "${var.environment}-${var.project-name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb-sg-id]
  subnets            = var.public-subnet-ids

  tags = {
    Name = "${var.environment}-${var.project-name}-alb"
  }
}

resource "aws_lb_target_group" "target-group" {
  name        = "${var.environment}-${var.project-name}-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc-id

  health_check {
    path    = var.health-check-path
    matcher = "200,302"
  }
}

resource "aws_lb_listener" "http-listeners" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https-listeners" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.alb-certificate-arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}