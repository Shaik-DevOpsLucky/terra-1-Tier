provider "aws" {
  region     = "ap-south-1"
}

resource "aws_instance" "one" {
  ami                    = "ami-009e46eef82e25fef"
  instance_type          = "t2.micro"
  key_name               = "mumbai-keypair"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "ap-south-1a"
  user_data              = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "Hello world" > /var/www/html/index.html
EOF
  tags = {
    Name = "web-server-1"
  }
}


resource "aws_security_group" "five" {
  name = "elb-sg"
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
}
