variable "environment" {
  type        = string
  description = "The environment of project"
}

variable "project-name" {
  description = "Name of project"
  type        = string
}

variable "website-bucket" {
  description = "This is the bucket used to host website"
}
