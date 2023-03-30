terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "gamera-terraform"
    key    = "development/frontend/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  region = "us-east-1"
  alias = "us-east-1"
}

module "s3" {
  source = "../../../modules/s3"

  environment       = var.environment
  project-name      = var.project-name
  cloudfront-oai-id = module.cloudfront.cloudfront-oai-id
}

module "cloudfront" {
  source = "../../../modules/cloudfront"

  environment    = var.environment
  project-name   = var.project-name
  hosted-zone    = var.hosted-zone
  record-prefix  = var.record-prefix
  website-bucket = module.s3.website-bucket
  acm-certificate-arn = module.acm.acm-certificate-arn
}

module "route53" {
  source = "../../../modules/route53"

  hosted-zone    = var.hosted-zone
  record-prefix  = var.record-prefix
  alias-dns-name = module.cloudfront.cloudfront-distribution.domain_name
  alias-zone-id  = module.cloudfront.cloudfront-distribution.hosted_zone_id
}

module "acm" {
  source = "../../../modules/acm"

  providers = {
    aws = aws.us-east-1
  }

  domain-name = "${var.record-prefix}.${var.hosted-zone}"
  hosted-zone-id = module.route53.hosted-zone-id
}