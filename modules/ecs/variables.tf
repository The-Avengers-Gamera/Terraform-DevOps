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

variable "gamera-target-groups" {
  description = "The target group for ECS services"
}

variable "public-subnet-ids" {
  description = "The public subnet ids"
}

variable "private-subnet-ids" {
  description = "The private subnet ids"
}

variable "ecs-sg" {
  description = "The security group for ecs service to allow inboud traffic from alb"
}
