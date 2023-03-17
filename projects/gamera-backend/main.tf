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
  source            = "../../modules/vpc"
  environment       = var.environment
  subnet-attributes = var.subnet-attributes
}

module "security-group" {
  source      = "../../modules/security-group"
  vpc-id      = module.gamera-vpc.vpc-id
  environment = var.environment
}

module "load-balancer" {
  source         = "../../modules/load-balancer"
  alb-sg-id      = module.security-group.alb-sg.id
  public-subnets = module.gamera-vpc.public-subnet-ids
}

module "ecr" {
  source      = "../../modules/ecr"
  environment = var.environment
}

module "rds" {
  source             = "../../modules/rds"
  environment        = var.environment
  dev-db-sg-id       = module.security-group.dev-db-sg-id
  prod-db-sg-id      = module.security-group.prod-db-sg-id
  public-subnet-ids  = module.gamera-vpc.public-subnet-ids
  private-subnet-ids = module.gamera-vpc.private-subnet-ids
}



