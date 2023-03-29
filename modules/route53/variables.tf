variable "hosted-zone" {
  type        = string
  description = "The name of hosted zone in route 53"
}

variable "record-prefix" {
  type        = string
  description = "The prefix of record to be created"
}

variable "alias-dns-name" {
  description = "The dns name of alias resource"
}

variable "alias-zone-id" {
  description = "The zone id of alias resource"
}