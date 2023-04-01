variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "project-name" {
  description = "Name of project"
  type        = string
}

variable "alb-sg-id" {
  type        = string
  description = "The security group id for load balancer"
}

variable "public-subnet-ids" {
  type        = list(string)
  description = "The id list of public subnets in VPC"
}

variable "vpc-id" {
  type        = string
  description = "The VPC id"
}

variable "alb-certificate-arn" {
  type        = string
  description = "The arn of certificate allocated to alb"
}

variable "health-check-path" {
  type        = string
  description = "The path for target group's health check"
}