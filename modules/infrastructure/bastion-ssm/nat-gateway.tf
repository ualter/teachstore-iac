locals {
    natgw_public_subnet       = element(var.public_subnets, 0)
    routetable_private_subnet = element(var.private_subnets, 0)
}

resource "aws_nat_gateway" "this" {
  count         = 1
  allocation_id = var.create_elastic_ip ? element(aws_eip.nat_eip.*.id, count.index) : var.elastic_ip_id
  #allocation_id = var.elastic_ip_id
  subnet_id     = local.natgw_public_subnet
  depends_on    = [data.aws_internet_gateway.default]

  tags = {
    Name         = "${var.environment}-bastion-natgateway"
    Unit         = var.unit
    Organization = var.organization
    Enviroment   = var.environment
  }
}


data "aws_route_table" "selected" {
  subnet_id = local.routetable_private_subnet
}

resource "aws_route" "route" {
  count                     = 1
  route_table_id            = data.aws_route_table.selected.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = element(aws_nat_gateway.this.*.id, count.index)
  #nat_gateway_id            = aws_nat_gateway.this.id
}