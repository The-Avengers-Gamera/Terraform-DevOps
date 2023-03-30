resource "random_string" "name-suffix" {
  length  = 8
  special = true
  override_special = "/_+=.@-"
}

resource "aws_secretsmanager_secret" "project-credentials" {
  name = "${var.environment}-${var.project-name}-credentials-${random_string.name-suffix.result}"
}

resource "aws_secretsmanager_secret_version" "project-credentials-version" {
  secret_id     = aws_secretsmanager_secret.project-credentials.id

  secret_string = jsonencode({
    endpoint = var.db-endpoint
    username = var.db-username
    password = var.db-password
    ecr-registry-id = var.ecr-registry-id
  })
}