output "alb-sg" {
  value       = aws_security_group.gamera-alb-sg
  description = "The security group for application load balancer"
}

output "dev-db-sg-id" {
  value       = aws_security_group.dev-db-sg.id
  description = "The security group for rds database in dev environment"
}

output "prod-db-sg-id" {
  value       = var.environment == "prod" ? aws_security_group.prod-db-sg[0].id : ""
  description = "The security group for rds database in prod environment"
}