resource "aws_vpc" "endpoint_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Endpoint_VPC"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.endpoint_vpc.id
}

resource "aws_subnet" "publicsubnet" {
    vpc_id = aws_vpc.endpoint_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2a"
}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.endpoint_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.Public.id
}