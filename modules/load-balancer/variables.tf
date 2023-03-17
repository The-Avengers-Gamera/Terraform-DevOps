variable "alb-sg-id" {
  type        = string
  description = "The security group id for load balancer"
}

variable "public-subnets" {
  type        = list(string)
  description = "The list of public subnets in VPC"
}
