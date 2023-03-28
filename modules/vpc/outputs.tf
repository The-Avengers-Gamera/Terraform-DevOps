output "vpc-id" {
  value       = aws_vpc.vpc.id
  description = "The VPC id"
}

output "public-subnet-ids" {
  value = [
    for subnet in aws_subnet.subnets :
    subnet.id
    if subnet.map_public_ip_on_launch == true
  ]
}

output "private-subnet-ids" {
  value = [
    for subnet in aws_subnet.subnets :
    subnet.id
    if subnet.map_public_ip_on_launch == false
  ]
}
