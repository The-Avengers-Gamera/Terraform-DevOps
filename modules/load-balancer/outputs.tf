output "target-group-arn" {
  value       = aws_lb_target_group.target-group.arn
  description = "The arn of target group for ECS services"
}

output "dns-name" {
  value       = aws_lb.alb.dns_name
  description = "The dns name of alb"
}

output "zone-id" {
  value       = aws_lb.alb.zone_id
  description = "The zone id of alb"
}