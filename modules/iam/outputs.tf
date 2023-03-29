output "ecs-task-execution-role-arn" {
  value       = aws_iam_role.ecs-task-execution-role.arn
  description = "The arn of aws managed task execution iam role"
}
