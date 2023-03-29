resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.environment}-${var.project-name}-ecs-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "fargate-provider" {
  cluster_name = aws_ecs_cluster.ecs-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "ecs-task-def" {
  family                   = "${var.environment}-${var.project-name}-task-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs-cpu
  memory                   = var.ecs-memory
  container_definitions = jsonencode([
    {
      name      = "${var.environment}-${var.project-name}-container"
      image     = "${var.ecr-url}:latest"
      cpu       = var.ecs-cpu
      memory    = var.ecs-memory
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  execution_role_arn = var.ecs-task-execution-role-arn
}

resource "aws_ecs_service" "service" {
  name            = "${var.environment}-${var.project-name}-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs-task-def.arn
  desired_count   = var.service-desired

  load_balancer {
    target_group_arn = var.target-group-arn
    container_name   = "${var.environment}-${var.project-name}-container"
    container_port   = 8080
  }

  network_configuration {
    subnets          = var.subnet-ids
    assign_public_ip = var.environment == "dev" ? true : false
    security_groups  = [var.ecs-sg-id]
  }
}
