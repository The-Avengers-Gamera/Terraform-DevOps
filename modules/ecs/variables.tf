variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "project-name" {
  description = "Name of project"
  type        = string
}

variable "ecr-url" {
  type        = string
  description = "The ECR repository's url"
}

variable "ecs-task-execution-role-arn" {
  description = "The arn of ECS task execution role"
  type        = string
}

variable "ecs-cpu" {
  description = "The cpu unit of ecs service"
  type        = number
}

variable "ecs-memory" {
  description = "The memory of ecs service"
  type        = number
}

variable "service-desired" {
  description = "The desired number of service running in cluster"
  type        = number
}

variable "target-group-arn" {
  description = "The arn of target group for ECS services"
  type        = string
}

variable "subnet-ids" {
  description = "The id list of subnets which are used to deploy ecs service"
  type        = list(string)
}

variable "ecs-sg-id" {
  description = "The security group id for ecs service to allow inboud traffic from alb"
  type        = string
}
