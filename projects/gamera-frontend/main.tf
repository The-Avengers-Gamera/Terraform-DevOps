terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "gamera-terraform"
    key = "richard/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {}

module "gamera-vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
}
