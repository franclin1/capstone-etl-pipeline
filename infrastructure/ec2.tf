resource "aws_instance" "app_server" {
  iam_instance_profile = "receipt-identification-appserver"
  vpc_security_group_ids = [ aws_security_group.inbound_outbound.id ]
  ami           = "ami-0a1ee2fb28fe05df3"
  instance_type = "t2.micro"
  key_name = "ec2access"
  subnet_id = aws_subnet.publicsubnet.id
  associate_public_ip_address = "true"
  tags = {
  Name = var.ec2_instance_name
  }

  provisioner "file" {
    source = "../python"
    destination = "/home/ec2-user"

    connection {
      type = "ssh"
      user = "ec2-user"
      host = aws_instance.app_server.public_ip
      private_key = file("/Users/malteahlers/Downloads/ec2access.pem")
      port = "22"
    } 
  }
}

resource "aws_security_group" "inbound_outbound" {
  name        = "P22and80"
  description = "Allow P22 and P80"
  vpc_id      = aws_vpc.endpoint_vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port        = 22
    to_port          = 22
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
    Name = "P22+88open"
  }
}


