resource "aws_db_instance" "postgres-db" {
  db_name           = "${var.environment}_${var.project-name}_db"
  identifier        = "${var.environment}-${var.project-name}-db"
  engine            = "postgres"
  allocated_storage = var.db-allocated-storage
  instance_class    = var.db-instance-class
  storage_type      = "gp2"

  username                  = "postgres"
  password                  = var.db-password
  parameter_group_name      = "default.postgres14"
  skip_final_snapshot       = var.environment == "dev" ? true : false
  final_snapshot_identifier = "${var.environment}-${var.project-name}-db-final-snapshot"
  publicly_accessible       = var.environment == "dev" ? true : false

  vpc_security_group_ids = [var.db-sg-id]
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-groups.name

  tags = {
    Name        = "${var.environment}-${var.project-name}-db"
    Environment = var.environment == "dev" ? "dev" : "prod"
  }
}

resource "aws_db_subnet_group" "db-subnet-groups" {
  name       = "${var.environment}-${var.project-name}-db-subnet-group"
  subnet_ids = var.subnet-ids

  tags = {
    Name = "${var.environment}-${var.project-name}-db-subnet-groups"
  }
}