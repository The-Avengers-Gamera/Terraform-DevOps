resource "aws_lb" "gamera-alb" {
  name               = "gamera-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb-sg-id]
  subnets            = var.public-subnets

  tags = {
    Name = "gamera-alb"
  }
}

resource "aws_lb_target_group" "gamera-target-groups" {
  count = var.environment == "prod" ? 2 : 1

  name        = "${count.index == 0 ? "uat" : "prod"}-gamera-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc-id
}

resource "aws_lb_listener" "gamera-listeners" {
  count = var.environment == "prod" ? 2 : 1

  load_balancer_arn = aws_lb.gamera-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gamera-target-groups[count.index].arn
  }
}

//alb rule needed