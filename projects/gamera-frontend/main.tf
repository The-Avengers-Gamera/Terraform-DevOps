terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "gamera-terraform"
    key    = "richard/frontend/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {}
