output "alb-sg" {
  value       = aws_security_group.gamera-alb-sg
  description = "The security group for application load balancer"
}
