variable "environment" {
  description = "Project environment, pass 'dev' or 'prod'"
  type        = string
}

variable "project-name" {
  description = "Name of project"
  type        = string
}

variable "hosted-zone" {
  description = "The name of hosted zone used in project"
  type        = string
}

variable "record-prefix" {
  description = "The prefix of record to be created"
  type        = string
}