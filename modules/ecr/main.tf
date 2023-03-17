resource "aws_ecr_repository" "gamera-ecr" {
  count = var.environment == "prod" ? 2 : 1

  name                 = count.index == 0 ? "dev-gamera-repo" : "prod-gamera-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}