output "gamera-ecr-url" {
  value       = aws_ecr_repository.gamera-ecr.*.repository_url
  description = "The ECR repository's urls"
} 