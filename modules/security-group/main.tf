resource "aws_security_group" "alb-sg" {
  name        = "${var.environment}-${var.project-name}-alb-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "Allow HTTPS access from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP access from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.project-name}alb-sg"
  }
}

resource "aws_security_group" "db-sg" {
  name = "${var.environment}-${var.project-name}-db-sg"
  description = (var.environment == "dev" ?
    "Allow postgres inbound traffic from anywhere" :
    "Allow postgres inbound traffic from prod ECS cluster"
  )
  vpc_id = var.vpc-id

  dynamic "ingress" {
    for_each = var.environment == "dev" ? ["anywhere"] : ["from_ecs"]
    content {
      from_port = 5432
      to_port   = 5432
      protocol  = "tcp"

      cidr_blocks     = ingress.value == "anywhere" ? ["0.0.0.0/0"] : []
      security_groups = ingress.value == "from_ecs" ? [aws_security_group.ecs-sg.id] : []
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.project-name}-db-sg"
  }
}

resource "aws_security_group" "ecs-sg" {
  name        = "${var.environment}-${var.project-name}-ecs-sg"
  description = "Allow inbound traffic from alb"
  vpc_id      = var.vpc-id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.project-name}-ecs-sg"
  }
}
