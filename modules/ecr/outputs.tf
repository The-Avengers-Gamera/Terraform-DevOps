output "ecr-url" {
  value       = aws_ecr_repository.ecr.repository_url
  description = "The ECR repository's url"
}

output "ecr-registry-id" {
  value       = aws_ecr_repository.ecr.registry_id
  description = "The registry id of ECR"
}