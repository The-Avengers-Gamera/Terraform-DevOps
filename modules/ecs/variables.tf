variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "gamera-ecr-url" {
  type        = list(string)
  description = "The ECR repository's urls"
}

variable "ecs-task-execution-role" {
  description = "The ECS task execution role"
}