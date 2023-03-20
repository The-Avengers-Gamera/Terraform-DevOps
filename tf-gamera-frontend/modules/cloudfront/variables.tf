variable "aliases" {
    description = ""
    type = string
    default = ["",""]
}

variable "bucket" {
    description = ""
    type = string
    default = ""
}

variable "prefix" {
    description = ""
    type = string
    default = "gamera"
}

variable "tags" {
    description = ""   
    type = string
    default = "gamera_demo"
}

variable "zone_id" {
    description = "route 53 zone ID"
    type = string
    default = ""
}