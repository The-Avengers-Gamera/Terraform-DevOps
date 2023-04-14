resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-${var.project-name}-vpc"
  }
}

resource "aws_subnet" "subnets" {
  count = length(var.subnet-attributes.cidr-blocks)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet-attributes.cidr-blocks[count.index]
  availability_zone       = var.subnet-attributes.availability-zones[count.index]
  map_public_ip_on_launch = var.subnet-attributes.if-public[count.index]

  tags = {
    Name = "${var.subnet-attributes.if-public[count.index] ? "public" : "private"}-${
    var.subnet-attributes.availability-zones[count.index]}-${var.project-name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-${var.project-name}-igw"
  }
}

resource "aws_eip" "eip" {
  count = var.environment == "prod" ? 1 : 0

  vpc = true

  tags = {
    Name = "prod-${var.project-name}-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  count = var.environment == "prod" ? 1 : 0

  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.subnets[0].id

  tags = {
    Name = "prod-${var.project-name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  /*
    This dynamic route rule is only for enable reverse proxy feature for Jenkins server
    This rule is unrelated to project, if cause any error, just delete this dynamic rule
  */
  dynamic "route" {
    for_each = var.environment == "dev" ? [1] : []
    content {
      cidr_block                = "172.31.0.0/16"
      vpc_peering_connection_id = "pcx-03ebb2b647deeda84"
    }
  }

  tags = {
    Name = "${var.environment}-${var.project-name}-public-route-table"
  }
}

resource "aws_route_table" "private-rt" {
  count = var.environment == "prod" ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }

  tags = {
    Name = "prod-${var.project-name}-private-route-table"
  }
}

resource "aws_route_table_association" "gamera_subnet_association" {
  count     = length(aws_subnet.subnets[*].id)
  subnet_id = aws_subnet.subnets[count.index].id

  route_table_id = (var.environment == "dev" ? aws_route_table.public-rt.id :
  (var.subnet-attributes.if-public[count.index] ? aws_route_table.public-rt.id : aws_route_table.private-rt[0].id))
}

