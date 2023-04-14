variable "environment" {
  description = "Project environment, pass 'dev' or 'prod'"
  type        = string
}

variable "project-name" {
  description = "Name of project"
  type        = string
}

variable "project-context" {
  description = "The context of project, pass 'frontend' or 'backend'"
  type        = string
}

variable "region" {
  description = "The region of project"
  type        = string
}

variable "subnet-attributes" {
  description = "Attributes for a list of subnets"
  type = object({
    cidr-blocks        = list(string)
    availability-zones = list(string)
    if-public          = list(bool)
  })
}

variable "hosted-zone" {
  description = "The name of hosted zone used in project"
  type        = string
}

variable "record-prefix" {
  description = "The prefix of record to be created"
  type        = string
}

variable "health-check-path" {
  description = "The health check path of target group"
  type        = string
}

variable "ecs-cpu" {
  description = "The cpu unit of ecs service"
  type        = number
}

variable "ecs-memory" {
  description = "The memory allocated yo ecs service"
  type        = number
}

variable "service-desired" {
  description = "The desired number of ecs service"
  type        = number
}

variable "db-allocated-storage" {
  description = "The allocated rds database storage"
  type        = number
}

variable "db-instance-class" {
  description = "The defined rds database instance class"
  type        = string
}

variable "openai-key" {
  description = "The key for openai"
  type        = string
}