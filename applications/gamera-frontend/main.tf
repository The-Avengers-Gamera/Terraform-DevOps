terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "gamera-terraform"
    key    = "richard/frontend/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {}

module "s3" {
  source              = "../../modules/s3"
  website-bucket-name = var.website-bucket-name
}

module "route53" {
  source             = "../../modules/route53"
  gamera-hosted-zone = var.gamera-hosted-zone
}

module "acm" {
  source                    = "../../modules/acm"
  domain-name               = "richard.${var.gamera-hosted-zone}"
  subject-alternative-names = var.subject-alternative-names
  hosted-zone-id            = module.route53.hosted-zone-id
}