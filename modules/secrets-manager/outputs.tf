output "db-password" {
  value       = aws_secretsmanager_secret_version.db-password.secret_string
  description = "The password generated for rds database"
}