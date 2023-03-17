variable "vpc-id" {
  type        = string
  description = "Id of the VPC in which to create the security groups"
}

variable "environment" {
  type        = string
  description = "The environment of project"
}
