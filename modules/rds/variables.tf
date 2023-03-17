variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "dev-db-sg-id" {
  type        = string
  description = "The security group's id for dev rds"
}

variable "prod-db-sg-id" {
  type        = string
  description = "The security group's id for prod rds"
}

variable "public-subnet-ids" {
  type        = list(string)
  description = "The list of public subnet's id"
}

variable "private-subnet-ids" {
  type        = list(string)
  description = "The list of private subnet's id"
}
