resource "aws_security_group" "gamera-alb-sg" {
  name        = "gamera-alb-sg"
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
    Name = "gamera-alb-sg"
  }
}

resource "aws_security_group" "dev-db-sg" {
  name        = "dev-db-sg"
  description = "Allow postgres inbound traffic from anywhere"
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 5432
    to_port     = 5432
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
    Name = "dev-db-sg"
  }
}

resource "aws_security_group" "prod-db-sg" {
  count = var.environment == "prod" ? 1 : 0

  name        = "prod-db-sg"
  description = "Allow postgres inbound traffic from prod ECS cluster"
  vpc_id      = var.vpc-id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.prod-ecs-sg[count.index].id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-db-sg"
  }
}


resource "aws_security_group" "dev-ecs-sg" {
  name        = "dev-ecs-sg"
  description = "Allow inbound traffic from alb"
  vpc_id      = var.vpc-id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.gamera-alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-ecs-sg"
  }
}


resource "aws_security_group" "prod-ecs-sg" {
  count = var.environment == "prod" ? 1 : 0

  name        = "prod-ecs-sg"
  description = "Allow inbound traffic from alb"
  vpc_id      = var.vpc-id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.gamera-alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-ecs-sg"
  }
}
