terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "gamera-terraform"
    key    = "richard/backend/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {}

module "vpc" {
  source            = "../../modules/vpc"
  environment       = var.environment
  subnet-attributes = var.subnet-attributes
  project-name = var.project-name
}

/*
locals {
  ecr-index = var.environment == "dev" ? 0 : 1
}


module "vpc" {
  source            = "../../modules/vpc"
  environment       = var.environment
  subnet-attributes = var.subnet-attributes
}

module "security-group" {
  source      = "../../modules/security-group"
  vpc-id      = module.vpc.vpc-id
  environment = var.environment
}

module "load-balancer" {
  source         = "../../modules/load-balancer"
  environment = var.environment
  alb-sg-id      = module.security-group.alb-sg.id
  public-subnets = module.vpc.public-subnet-ids
  vpc-id = module.vpc.vpc-id
}

module "ecr" {
  source      = "../../modules/ecr"
  environment = var.environment
}

module "ecs" {
  source                  = "../../modules/ecs"
  environment             = var.environment
  gamera-ecr-url          = module.ecr.gamera-ecr-url
  ecs-task-execution-role = module.iam.ecs-task-execution-role
  gamera-target-groups = module.load-balancer.gamera-target-groups
  public-subnet-ids = module.vpc.public-subnet-ids
  private-subnet-ids = module.vpc.private-subnet-ids
  ecs-sg = module.security-group.ecs-sg

  depends_on = [null_resource.push-default-image]
}

module "iam" {
  source = "../../modules/iam"
}

module "rds" {
  source             = "../../modules/rds"
  environment        = var.environment
  dev-db-sg-id       = module.security-group.dev-db-sg-id
  prod-db-sg-id      = module.security-group.prod-db-sg-id
  public-subnet-ids  = module.vpc.public-subnet-ids
  private-subnet-ids = module.vpc.private-subnet-ids
}

resource "null_resource" "push-default-image" {
  depends_on = [module.ecr]

  provisioner "local-exec" {
    command = "${path.module}/push-image.sh"
    environment = {
      ECR_REGISTRY_ID = module.ecr.gamera-ecr-registry-id[local.ecr-index]
      ECR_URL         = module.ecr.gamera-ecr-url[local.ecr-index]
    }
  }
}
*/