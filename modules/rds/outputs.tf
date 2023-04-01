output db-endpoint {
  value       = aws_db_instance.postgres-db.endpoint
  description = "The endpoint of RDS database"
}

output db-username {
  value       = aws_db_instance.postgres-db.username
  description = "The username of RDS database"
}

output db-password {
  value       = random_password.db-password.result
  description = "The password of RDS database"
  sensitive = true
}