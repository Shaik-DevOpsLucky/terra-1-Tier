provider "aws" {
  region  = var.region
}

resource "aws_instance" "demo-server" {
  ami                          = var.os-name
  key_name                     = var.key
  instance_type                = var.instance-type
  associate_public_ip_address  = true
  subnet_id                    = aws_subnet.demo_subnet.id
  vpc_security_group_ids       = [aws_security_group.demo-vpc-sg.id]
  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "hai all this is my app created by terraform infrastructure by Moulali server-1" > /var/www/html/index.html
              EOF

  tags = {
    Name = "demo-terraform-EC2"
  }
}

// Create VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "demo-vpc"
  }
}

// Create Subnet
resource "aws_subnet" "demo_subnet" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.subnet1-cidr
  availability_zone = var.subnet1-az

  tags = {
    Name = "demo-subnet"
  }
}

// Create Internet Gateway
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

// Create route table
resource "aws_route_table" "demo-rtb" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }

  tags = {
    Name = "demo-rtb"
  }
}

// Associate subnet with route table
resource "aws_route_table_association" "demo-rtb_association" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo-rtb.id
}

// Create a security group
resource "aws_security_group" "demo-vpc-sg" {
  name        = "demo-vpc-sg"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_s3_bucket" "six" {
  bucket = "devopsbyshaikmoula3889900"
}
