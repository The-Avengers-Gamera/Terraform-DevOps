variable "alb-sg-id" {
  type        = string
  description = "The security group id for load balancer"
}

variable "public-subnets" {
  type        = list(string)
  description = "The list of public subnets in VPC"
}

variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "vpc-id" {
  type = string
  description = "The VPC id"
}