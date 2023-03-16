variable "environment" {
  description = "Project environment, pass 'dev' or 'prod"
  type        = string
  default     = "dev"
}

variable "subnet-attributes" {
  description = "Attributes for a list of subnets, follow the type required"

  type = object({
    cidr-blocks        = list(string)
    availability-zones = list(string)
    if-public          = list(bool)
  })

  default = {
    cidr-blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24",
    "10.0.5.0/24", "10.0.6.0/24"]
    availability-zones = ["ap-southeast-2a", "ap-southeast-2a", "ap-southeast-2b",
    "ap-southeast-2b", "ap-southeast-2c", "ap-southeast-2c"]
    if-public = [true, false, true, false, true, false]
  }
}