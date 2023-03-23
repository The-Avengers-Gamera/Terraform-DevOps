variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "gamera-hosted-zone" {
  type        = string
  description = "The name of hosted zone in route 53"
}

variable "cloudfront-distributions" {
  description = "This is the list of cloudfront distributions"
}