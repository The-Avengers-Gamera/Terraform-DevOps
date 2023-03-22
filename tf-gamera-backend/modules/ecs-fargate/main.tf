resource "aws_ecs_cluster" "demo_ecs_cluster" {
  name = "demo_ecs_cluster"
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.demo_ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_service" "demo_ecs_service" {
  name            = "demo_ecs_service"
  cluster         = aws_ecs_cluster.demo_ecs_cluster.id
  task_definition = aws_ecs_task_definition.demo_task_def.arn
  desired_count   = 2
  iam_role        = aws_iam_role.task_excution_role.arn
  depends_on      = [aws_iam_role_policy.task_excution_role]
  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn ## todo after vpc
    container_name   = var.container_name
    container_port   = var.container_port
  }
  lifecycle {
    ignore_changes = [desired_count]
  }
  network_configuration {
    subnets         = aws_subnet.private.*.id  ##  todo after vpc
    security_groups = [aws_security_group.ecs_service.id] ## todo after vpc
    assign_public_ip = "ENABLED"
  }
}

resource "aws_ecs_task_definition" "demo_task_def" {
  family                   = "demo_task_def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 3072
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "${container_name}",
    "image": "",  ### todo later
    "cpu": 1024,
    "memory": 3072,
    "essential": true
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}