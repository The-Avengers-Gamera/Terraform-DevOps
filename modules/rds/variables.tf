variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "project-name" {
  description = "Name of project"
  type        = string
}

variable "db-sg-id" {
  type        = string
  description = "The security group's id for rds"
}

variable "subnet-ids" {
  type        = list(string)
  description = "The list of subnet's id"
}

variable "db-allocated-storage" {
  description = "The allocated rds database storage"
  type        = number
}

variable "db-instance-class" {
  description = "The defined rds database instance class"
  type        = string
}

variable "db-password" {
  description = "The password generated for rds database"
  type        = string
}
