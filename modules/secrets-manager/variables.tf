variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "project-name" {
  description = "Name of project"
  type        = string
}

variable "project-context" {
  description = "The context of project, pass 'frontend' or 'backend'"
  type        = string
}

variable "db-endpoint" {
  description = "The endpoint of RDS database"
  type        = string
}

variable "db-username" {
  description = "The username of RDS database"
  type        = string
}

variable "db-password" {
  description = "The password of RDS database"
  type        = string
}

variable "ecr-registry-id" {
  description = "The registry if of ECR"
  type        = string
}

variable "cloudfront-id" {
  description = "The id of cloudfront distribution"
  type        = string
}

variable "bucket-name" {
  description = "The name of bucket which host website"
  type        = string
}

variable "openai-key" {
  description = "The key for openai"
  type        = string
}