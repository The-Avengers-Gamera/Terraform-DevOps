output "vpc-id" {
  value       = aws_vpc.gamera-vpc.id
  description = "The VPC id"
}

output "public-subnet-ids" {
  value = [
    for subnet in aws_subnet.gamera-subnets :
    subnet.id
    if subnet.map_public_ip_on_launch == true
  ]
}

output "private-subnet-ids" {
  value = [
    for subnet in aws_subnet.gamera-subnets :
    subnet.id
    if subnet.map_public_ip_on_launch == false
  ]
}
