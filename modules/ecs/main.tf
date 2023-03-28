resource "aws_ecs_cluster" "gamera-ecs-cluster" {
  name = "gamera-ecs-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "fargate-provider" {
  cluster_name = aws_ecs_cluster.gamera-ecs-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "gamera-ecs-task-def" {
  count = var.environment == "prod" ? 2 : 1

  family = count.index == 0 ? "gamera-uat-task" : "gamera-prod-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = count.index == 0 ? 512 : 1024
  memory                   = count.index == 0 ? 1024 : 2048
  container_definitions = jsonencode([
    {
      name      = count.index == 0 ? "gamera-container-uat" : "gamera-container-prod"
      image     = "${var.gamera-ecr-url[count.index]}:latest"
      cpu       = count.index == 0 ? 512 : 1024
      memory    = count.index == 0 ? 1024 : 2048
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

  execution_role_arn = var.ecs-task-execution-role.arn
}

resource "aws_ecs_service" "gamera-services" {
  count = var.environment == "prod" ? 2 : 1

  name            = "gamera-${count.index == 0 ? "uat" : "prod"}"
  cluster         = aws_ecs_cluster.gamera-ecs-cluster.id
  task_definition = aws_ecs_task_definition.gamera-ecs-task-def[count.index].arn
  desired_count   = count.index == 0 ? 1 : 3

  load_balancer {
    target_group_arn = var.gamera-target-groups[count.index].arn
    container_name   = "gamera-container-${count.index == 0 ? "uat" : "prod"}"
    container_port   = 8080
  }

  network_configuration {
    subnets = count.index == 0 ? var.public-subnet-ids : var.private-subnet-ids
    assign_public_ip = count.index == 0 ? true : false
    security_groups = [var.ecs-sg.id]
  }
}
