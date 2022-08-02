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

resource "aws_subnet" "publicsubnet1" {
    vpc_id = aws_vpc.endpoint_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-central-1a"
}

resource "aws_subnet" "publicsubnet2" {
    vpc_id = aws_vpc.endpoint_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-central-1b"
}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.endpoint_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_security_group" "inbound_outbound" {
  name        = "P80"
  description = "Allow P80"
  vpc_id      = aws_vpc.endpoint_vpc.id

  ingress {
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
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "80open"
  }
}