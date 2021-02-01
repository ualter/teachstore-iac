
resource "aws_subnet" "created" {
  count      = local.subnet_bastion == "" ? 1 : 0
  vpc_id     = var.vpc_id
  cidr_block = var.private_subnet_cidr_block

  tags = {
    Name         = "private-${var.environment}-bastion"
    Unit         = var.unit
    Organization = var.organization
    Enviroment   = var.environment
    Type         = "private"
  }
}

resource "aws_route_table" "rt" {
  count  = local.subnet_bastion == "" ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this.*.id, count.index)
  }

  tags = {
    Name         = "private-${var.environment}-bastion"
    Unit         = var.unit
    Organization = var.organization
    Enviroment   = var.environment
  }
}

resource "aws_route_table_association" "rt-subnet" {
  count          = local.subnet_bastion == "" ? 1 : 0
  subnet_id      = element(aws_subnet.created.*.id, count.index)
  route_table_id = element(aws_route_table.rt.*.id, count.index)
}
