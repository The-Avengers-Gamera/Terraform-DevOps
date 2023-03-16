resource "aws_vpc" "gamera-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "gamera-vpc"
  }
}

resource "aws_subnet" "gamera-subnets" {
  count                   = length(var.subnet-attributes.cidr-blocks)
  vpc_id                  = aws_vpc.gamera-vpc.id
  cidr_block              = var.subnet-attributes.cidr-blocks[count.index]
  availability_zone       = var.subnet-attributes.availability-zones[count.index]
  map_public_ip_on_launch = var.subnet-attributes.if-public[count.index]

  tags = {
    Name = "${var.subnet-attributes.if-public[count.index] ? "public" : "private"}-${
    var.subnet-attributes.availability-zones[count.index]}"
  }
}

/*
resource "aws_route_table" "gamera-rtb" {
    default_route_table_id = aws_vpc.gamera-vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_interne
    }
}

resource "aws_internet_gateway" "gamera-igw" {

}

output name {
  value       = ""
  sensitive   = true
  description = "description"
  depends_on  = []
}
*/



