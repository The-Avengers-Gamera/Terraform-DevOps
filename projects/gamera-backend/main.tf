terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "richard-gamera-terraform"
    key    = "backend/state.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {}

module "gamera-vpc" {
  source = "../../modules/vpc"
}