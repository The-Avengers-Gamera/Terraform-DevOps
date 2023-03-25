output "ecs-task-execution-role" {
  value       = aws_iam_role.ecs-task-execution-role
  description = "The aws managed task execution iam role"
}
