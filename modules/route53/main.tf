data "aws_route53_zone" "gamera-hosted-zone" {
  name         = var.gamera-hosted-zone
  private_zone = false
}