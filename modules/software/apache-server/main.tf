##
## This a simple module only intented to be used for testing of 
## Networking, Bastion (SSM PortForward), etc.
##

provider "aws" {
    region = var.region
}

resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default_az" {
  availability_zone = var.az
}

resource "aws_security_group" "ssh" {
  name   = "ssh"
  vpc_id = aws_default_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "apache" {
  name   = "apache"
  vpc_id = aws_default_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_instance" "myInstance" {
  ami           = "ami-0d3f551818b21ed81"
  instance_type = "t2.micro"
  subnet_id     = aws_default_subnet.default_az.id
  key_name      = var.ec2_key_pair_name

  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.apache.id]

  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  apt update
                  apt install -y apache2
                  echo "<img src='/icons/ubuntu-logo.png'><font style='font-family:Arial'><h3>Apache2 Ubuntu - EC2 Instance - t2.micro - Ubuntu 20.4 - ami-0d3f551818b21ed81</h3>" > /var/www/html/index.html
                  systemctl start apache2
                  EOF
}

output "DNS" {
  value = aws_instance.myInstance.public_dns
}