terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "gamera-terraform"
    key    = "development/frontend/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {}

module "s3" {
  source      = "../../../modules/s3"

  environment = var.environment
  project-name = var.project-name
}

module "cloudfront" {
  source     = "../../../modules/cloudfront"

  environment  = var.environment
  project-name = var.project-name
  website-bucket = module.s3.website-bucket
}

/*
module "route53" {
  source             = "../../../modules/route53"
  environment                 = var.environment
  gamera-hosted-zone = var.gamera-hosted-zone
  cloudfront-distributions = module.cloudfront.cloudfront-distributions
}


*/