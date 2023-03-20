terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  }

# ACM-Certificate
module "ACM-Certificate" {
  source = "./modules/ACM-Certificate"
}

module "Cloudfront" {
  source = "./modules/cloudfront"   
}

module "Route53" {
  source = "./modules/route53"
}

module "S3_static_website" {
  source = "./modules/S3_static_website"
}