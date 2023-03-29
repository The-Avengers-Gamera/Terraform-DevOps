variable "environment" {
  default = "dev"
}

variable "website-bucket-name" {
  default = "richard-tf.gamera.com.au"
}

variable "gamera-hosted-zone" {
  default = "gamera.com.au"
}

variable "subject-alternative-names" {
  default = ["dev.richard.gamera.com.au", "prod.richard.gamera.com.au"]
}