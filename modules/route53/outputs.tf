output "hosted-zone-id" {
  value       = data.aws_route53_zone.hosted-zone.zone_id
  description = "The id of hosted zone"
}