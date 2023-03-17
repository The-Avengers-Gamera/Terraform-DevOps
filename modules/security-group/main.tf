resource "aws_security_group" "gamera-alb-sg" {
  name        = "gamera-alb-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description      = "Allow HTTPS access from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP access from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gamera-alb-sg"
  }
}