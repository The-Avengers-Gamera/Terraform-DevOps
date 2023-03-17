resource "aws_db_instance" "gamera-postgres-db" {
  count = var.environment == "prod" ? 2 : 1

  db_name           = "${count.index == 0 ? "dev" : "prod"}_gamera_db"
  engine            = "postgres"
  allocated_storage = count.index == 0 ? 10 : 50
  instance_class    = count.index == 0 ? "db.t3.micro" : "db.t3.medium"
  storage_type      = "gp2"

  username             = "postgres"
  password             = random_password.rds-random-password[count.index].result
  parameter_group_name = "default.postgres14"
  skip_final_snapshot       = false
  final_snapshot_identifier = "${count.index == 0 ? "dev" : "prod"}-gamera-db-final-snapshot"
  publicly_accessible  = count.index == 0

  vpc_security_group_ids = [
    count.index == 0 ? var.dev-db-sg-id : var.prod-db-sg-id
  ]
  db_subnet_group_name = aws_db_subnet_group.gamera-db-subnet-groups[count.index].name

  tags = {
    Name        = "${count.index == 0 ? "dev" : "prod"}-gamera-db"
    Environment = count.index == 0 ? "dev" : "prod"
  }
}

resource "random_password" "rds-random-password" {
  count   = var.environment == "prod" ? 2 : 1
  length  = 16
  special = true
}

resource "aws_db_subnet_group" "gamera-db-subnet-groups" {
  count = var.environment == "prod" ? 2 : 1

  name       = "${count.index == 0 ? "dev" : "prod"}-db-subnet-group"
  subnet_ids = count.index == 0 ? var.public-subnet-ids : var.private-subnet-ids

  tags = {
    Name = "${count.index == 0 ? "dev" : "prod"}-db-subnet-groups"
  }
}