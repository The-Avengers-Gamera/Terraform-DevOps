variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "project-name" {
  description = "Name of project"
  type        = string
}
variable "cloudfront-oai-id" {
  description = "The id of cloudfront's origin access identity"
  type        = string
}