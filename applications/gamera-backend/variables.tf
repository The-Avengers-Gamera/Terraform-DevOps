variable "environment" {
  description = "Project environment, pass 'dev' or 'prod'"
  type        = string
}

variable "project-name" {
  description = "Name of project"
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
  description = "The name of hosted zone used in proejct"
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