resource "aws_iam_role" "task_excution_role" {
  name = "task_excution_role"
  assume_role_policy = jsonencode({
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "ecs_task_excution_role_policy" {
  role       = aws_iam_role.task_excution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

