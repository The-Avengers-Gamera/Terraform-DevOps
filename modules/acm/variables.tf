variable "subject-alternative-names" {
  type        = list(string)
  description = "The SANs of ACM certificate"
}

variable "hosted-zone-id" {
  type        = string
  description = "The id of route53's hosted zone"
}