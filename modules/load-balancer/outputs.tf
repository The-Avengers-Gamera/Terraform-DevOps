output gamera-target-groups {
  value       = aws_lb_target_group.gamera-target-groups.*
  description = "The target group for ECS services"
}
