terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_zone" "dev" {
  name = var.subdomain_name

  tags = {
    Environment = var.tags
  }
}

resource "aws_route53_record" "dev-ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.subdomain_name
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.dev.name_servers
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.subdomain_name
  type    = "A"

  alias {
    name                   = aws_elb.main.dns_name
    zone_id                = aws_elb.main.zone_id
    evaluate_target_health = true
  }
}