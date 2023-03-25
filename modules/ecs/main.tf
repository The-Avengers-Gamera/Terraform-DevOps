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

resource "aws_ecs_task_definition" "gamera-ecs-service" {
  count = var.environment == "prod" ? 2 : 1

  family = count.index == 0 ? "gamera-uat-task" : "gamera-prod-task"
  container_definitions = jsonencode([
    {
      name      = count.index == 0 ? "gamera-container-uat" : "gamera-container-prod"
      image     = "${var.gamera-ecr-url[count.index]}:latest"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
    }
  ])

  execution_role_arn = var.ecs-task-execution-role.arn

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [ap-southeast-2]"
  }
}