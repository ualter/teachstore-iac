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
  count  = !var.private_server ? 1 : 0
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

locals {
  descrip_sg_apache    = !var.private_server ? "Allow HTTP inbound traffic" : "Allow Internal HTTP inbound traffic"
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_security_group" "apache" {
  name   = "apache"
  vpc_id = aws_default_vpc.default.id
  description = local.descrip_sg_apache

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group_rule" "apache-public" {
  count             = var.private_server ? 0 : 1
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.apache.id
  cidr_blocks       = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "apache-private" {
  count                    = var.private_server ? 1 : 0
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.apache.id
  source_security_group_id = aws_security_group.apache.id
}

resource "aws_security_group_rule" "bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.apache.id
  source_security_group_id = var.bastion_source_security_group_id
}

resource "aws_instance" "myInstance" {
  count                       = 1
  ami                         = "ami-0d3f551818b21ed81"
  instance_type               = "t2.micro"
  subnet_id                   = aws_default_subnet.default_az.id
  key_name                    = var.ec2_key_pair_name
  associate_public_ip_address = var.private_server ? false : true

  vpc_security_group_ids = var.private_server ? [aws_security_group.apache.id] : [element(aws_security_group.ssh.*.id,count.index), aws_security_group.apache.id]

  tags = {
    Name = "Apacher Server"
    Type = var.private_server ? "private" : "public"
  }

  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  apt update
                  apt install -y apache2
                  echo "<img src='/icons/ubuntu-logo.png'><font style='font-family:Arial'><h3>Apache2 Ubuntu - EC2 Instance - t2.micro - Ubuntu 20.4 - ami-0d3f551818b21ed81</h3>" > /var/www/html/index.html
                  systemctl start apache2
                  cat ~/.ssh/authorized_keys
                  EOF
}

output "DNS" {
  value = var.private_server ? element(aws_instance.myInstance.*.private_ip,0) : element(aws_instance.myInstance.*.public_dns,0)
}