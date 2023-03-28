output "alb-sg" {
  value       = aws_security_group.alb-sg
  description = "The security group for application load balancer"
}

output "db-sg-id" {
  value       = aws_security_group.db-sg.id
  description = "The security group for rds database"
}

output "ecs-sg-id" {
  value       = aws_security_group.ecs-sg.id
  description = "The security group for ecs service"
}