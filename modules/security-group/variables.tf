variable "environment" {
  description = "Project environment, pass 'dev' or 'prod"
  type        = string
}

variable "project-name" {
  description = "Name of project"
  type        = string
}

variable "vpc-id" {
  type        = string
  description = "Id of the VPC in which to create the security groups"
}