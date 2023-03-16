terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "richard-gamera-terraform"
    key = "frontend/state.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {}