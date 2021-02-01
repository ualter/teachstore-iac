provider "aws" {
  region  = var.aws_region
}

resource "aws_security_group" "this" {
  name   = "${var.environment}-bastion"
  vpc_id = var.vpc_id

  # Nope!
  #ingress {
  #  protocol    = "tcp"
  #  from_port   = 22
  #  to_port     = 22
  #  cidr_blocks = var.allowed_cidr_blocks
  #}

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "${var.environment}-bastion"
    Unit         = var.unit
    Organization = var.organization
    Enviroment   = var.environment
  }
}

locals {
  #subnet_bastion = element(var.private_subnets, 0)
  subnet_bastion = var.private_subnets[0]
}


## NEXT SESSION....
## Test with Subnet already create and NOT create (created by the module)
## OK - Done! - Test with Elastic IP already created and NOT created (create by the module)

resource "aws_instance" "this" {
  count                       = 1
  ami                         = data.aws_ami.this.id
  key_name                    = var.ec2_key_pair_name
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.this.name
  subnet_id                   = local.subnet_bastion == "" ? element(aws_subnet.created.*.id,count.index) : local.subnet_bastion
  associate_public_ip_address = false

  vpc_security_group_ids = concat(var.ext_security_groups, [
    aws_security_group.this.id
  ])

  tags = {
    Name         = "${var.environment}-bastion"
    Unit         = var.unit
    Organization = var.organization
    Enviroment   = var.environment
  }
}