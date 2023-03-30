terraform {
  required_version = "~> 1.4"

  backend "s3" {
    bucket = "gamera-terraform"
    key    = "production/backend/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {}

module "vpc" {
  source = "../../../modules/vpc"

  environment       = var.environment
  project-name      = var.project-name
  subnet-attributes = var.subnet-attributes
}

module "security-group" {
  source = "../../../modules/security-group"

  environment  = var.environment
  project-name = var.project-name
  vpc-id       = module.vpc.vpc-id
}

module "route53" {
  source = "../../../modules/route53"

  hosted-zone    = var.hosted-zone
  record-prefix  = var.record-prefix
  alias-dns-name = module.load-balancer.dns-name
  alias-zone-id  = module.load-balancer.zone-id
}

module "acm" {
  source = "../../../modules/acm"

  domain-name    = "${var.record-prefix}.${var.hosted-zone}"
  hosted-zone-id = module.route53.hosted-zone-id
}

module "load-balancer" {
  source = "../../../modules/load-balancer"

  environment         = var.environment
  project-name        = var.project-name
  alb-sg-id           = module.security-group.alb-sg-id
  public-subnet-ids   = module.vpc.public-subnet-ids
  vpc-id              = module.vpc.vpc-id
  alb-certificate-arn = module.acm.acm-certificate-arn
  health-check-path   = var.health-check-path
}

module "iam" {
  source = "../../../modules/iam"
}

module "ecr" {
  source = "../../../modules/ecr"

  environment  = var.environment
  project-name = var.project-name
}

module "ecs" {
  source = "../../../modules/ecs"

  environment                 = var.environment
  project-name                = var.project-name
  ecr-url                     = module.ecr.ecr-url
  ecs-task-execution-role-arn = module.iam.ecs-task-execution-role-arn
  ecs-cpu                     = var.ecs-cpu
  ecs-memory                  = var.ecs-memory
  service-desired             = var.service-desired
  target-group-arn            = module.load-balancer.target-group-arn
  subnet-ids                  = var.environment == "dev" ? module.vpc.public-subnet-ids : module.vpc.private-subnet-ids
  ecs-sg-id                   = module.security-group.ecs-sg-id

  depends_on = [null_resource.push-default-image]
}

module "rds" {
  source = "../../../modules/rds"

  environment          = var.environment
  project-name         = var.project-name
  db-sg-id             = module.security-group.db-sg-id
  subnet-ids           = var.environment == "dev" ? module.vpc.public-subnet-ids : module.vpc.private-subnet-ids
  db-allocated-storage = var.db-allocated-storage
  db-instance-class    = var.db-instance-class
}

module "secrets-manager" {
  source = "../../../modules/secrets-manager"

  environment  = var.environment
  project-name = var.project-name
  project-context = var.project-context
  db-endpoint = module.rds.db-endpoint
  db-username = module.rds.db-username
  db-password = module.rds.db-password
  ecr-registry-id = module.ecr.ecr-registry-id

  cloudfront-id = ""
  bucket-name = ""
}

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