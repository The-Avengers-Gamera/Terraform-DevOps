output "gamera-ecr-url" {
  value       = aws_ecr_repository.gamera-ecr.*.repository_url
  description = "The ECR repository's urls"
} 

output "gamera-ecr-registry-id" {
  value = aws_ecr_repository.gamera-ecr.*.registry_id
  description = "The registry id of ECR"
}