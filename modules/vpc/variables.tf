variable "environment" {
  description = "Project environment, pass 'dev' or 'prod"
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