terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "gamera-terraform"
    key    = "richard/backend/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {}

module "gamera-vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
}

module "security-group" {
  source = "../../modules/security-group"
  vpc-id = module.gamera-vpc.vpc-id
}

module load-balancer {
  source = "../../modules/load-balancer"
  alb-sg-id = module.security-group.alb-sg.id
  public-subnets = module.gamera-vpc.public-subnet-ids
}



