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