resource "aws_ecr_repository" "gamera-ecr" {
  count = var.environment == "prod" ? 2 : 1

  name                 = var.environment == "prod" ? "prod-gamera-repo" : "dev-gamera-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}