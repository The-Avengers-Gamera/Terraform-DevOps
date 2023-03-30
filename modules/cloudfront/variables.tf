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

variable "hosted-zone" {
  type        = string
  description = "The name of hosted zone in route 53"
}

variable "record-prefix" {
  type        = string
  description = "The prefix of record to be created"
}

variable "acm-certificate-arn" {
  type = string
  description = "The arn of acm provisoned certificate"
}