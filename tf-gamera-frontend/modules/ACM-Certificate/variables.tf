variable "domain_name" {
    description = "The domain name for the ACM certificate"
    type = string
    default = "ron828.net"
}

variable "validation_method" {
    description = "The validation method to use for the ACM certificate"
    type = string
    default     = "DNS"
}

variable "tags" {
    description = "assign the tag to the resource"
    type = string
    default = "gamera"
}

variable "domain" {
    description = "issued domain name"
    type = string
    default = "ron828.net"
}

variable "statuses" {
    description = "the status of the issued domain name"
    type = list(string)
    default = [ "ISSUED" ]
}

variable "zone_id" {
    description = "aws route53 zone ID"  
    type = string
    default = ""
}