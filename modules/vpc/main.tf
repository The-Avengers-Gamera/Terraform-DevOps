resource "aws_vpc" "gamera-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "gamera-vpc"
  }
}

resource "aws_subnet" "gamera-subnets" {
  count = length(var.subnet-attributes.cidr-blocks)

  vpc_id                  = aws_vpc.gamera-vpc.id
  cidr_block              = var.subnet-attributes.cidr-blocks[count.index]
  availability_zone       = var.subnet-attributes.availability-zones[count.index]
  map_public_ip_on_launch = var.subnet-attributes.if-public[count.index]

  tags = {
    Name = "${var.subnet-attributes.if-public[count.index] ? "public" : "private"}-${
    var.subnet-attributes.availability-zones[count.index]}"
  }
}

resource "aws_eip" "gamera-eip" {
  count = var.environment == "prod" ? 1 : 0

  vpc = true

  tags = {
    Name = "gamera-eip"
  }
}

resource "aws_internet_gateway" "gamera-igw" {
  vpc_id = aws_vpc.gamera-vpc.id

  tags = {
    Name = "gamera-igw"
  }
}

resource "aws_nat_gateway" "gamera-ngw" {
  count = var.environment == "prod" ? 1 : 0

  allocation_id = aws_eip.gamera-eip[0].id
  subnet_id     = aws_subnet.gamera-subnets.*.id[0]

  tags = {
    Name = "gamera-nat-gateway"
  }

  depends_on = [aws_internet_gateway.gamera-igw]
}


resource "aws_route_table" "gamera-public-rt" {
  vpc_id = aws_vpc.gamera-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gamera-igw.id
  }

  tags = {
    Name = "gamera-public-route-table"
  }
}


resource "aws_route_table" "gamera-private-rt" {
  vpc_id = aws_vpc.gamera-vpc.id

  dynamic "route" {
    for_each = var.environment == "prod" ? [1] : []

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.gamera-ngw[0].id
    }
  }

  tags = {
    Name = "gamera-private-route-table"
  }
}


resource "aws_route_table_association" "gamera_subnet_association" {
  count     = length(aws_subnet.gamera-subnets[*].id)
  subnet_id = aws_subnet.gamera-subnets[count.index].id

  route_table_id = (var.subnet-attributes.if-public[count.index] ?
    aws_route_table.gamera-public-rt.id :
  aws_route_table.gamera-private-rt.id)
}

