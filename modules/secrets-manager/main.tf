resource "random_password" "master" {
  length           = 32
  special          = true
  override_special = "_%+^!#()-=[]{}<>?"
}

resource "aws_secretsmanager_secret" "db-password" {
  name = "${var.environment}-${var.project-name}-db-password"
}

resource "aws_secretsmanager_secret_version" "db-password" {
  secret_id     = aws_secretsmanager_secret.db-password.id
  secret_string = random_password.master.result
}