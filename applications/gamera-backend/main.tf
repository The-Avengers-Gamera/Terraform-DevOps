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
  source = "../../modules/vpc"

  environment       = var.environment
  project-name      = var.project-name
  subnet-attributes = var.subnet-attributes
}

module "security-group" {
  source = "../../modules/security-group"

  environment  = var.environment
  project-name = var.project-name
  vpc-id       = module.vpc.vpc-id
}

module "route53" {
  source = "../../modules/route53"

  hosted-zone    = var.hosted-zone
  record-prefix  = var.record-prefix
  alias-dns-name = module.load-balancer.dns-name
  alias-zone-id  = module.load-balancer.zone-id
}

module "acm" {
  source = "../../modules/acm"

  domain-name    = "${var.record-prefix}.${var.hosted-zone}"
  hosted-zone-id = module.route53.hosted-zone-id
}

module "load-balancer" {
  source = "../../modules/load-balancer"

  environment         = var.environment
  project-name        = var.project-name
  alb-sg-id           = module.security-group.alb-sg-id
  public-subnet-ids   = module.vpc.public-subnet-ids
  vpc-id              = module.vpc.vpc-id
  alb-certificate-arn = module.acm.acm-certificate-arn
  health-check-path   = var.health-check-path
}

module "iam" {
  source = "../../modules/iam"
}

module "ecr" {
  source = "../../modules/ecr"

  environment  = var.environment
  project-name = var.project-name
}


/*
locals {
  ecr-index = var.environment == "dev" ? 0 : 1
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



module "rds" {
  source             = "../../modules/rds"
  environment        = var.environment
  dev-db-sg-id       = module.security-group.dev-db-sg-id
  prod-db-sg-id      = module.security-group.prod-db-sg-id
  public-subnet-ids  = module.vpc.public-subnet-ids
  private-subnet-ids = module.vpc.private-subnet-ids
}

*/
resource "null_resource" "push-default-image" {
  depends_on = [module.ecr]

  provisioner "local-exec" {
    command = "${path.module}/push-image.sh"
    environment = {
      REGION          = var.region
      ECR_REGISTRY_ID = module.ecr.ecr-registry-id
      ECR_URL         = module.ecr.ecr-url
    }
  }
}
