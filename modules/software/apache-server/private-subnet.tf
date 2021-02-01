# NAT Gateway
# Get the NAT Gateway that already exist throughout the SubnetId informed (where it is installed)
data "aws_nat_gateway" "default" {
  count     = var.nat_gateway_subnet_id != "" ? 1 : 0
  subnet_id = var.nat_gateway_subnet_id
}

# Create the Private Subnet ini case the Server it is Private
resource "aws_subnet" "created" {
  count      = var.private_server ? 1 : 0
  vpc_id     = aws_default_vpc.default.id
  cidr_block = var.private_subnet_cidr_block

  tags = {
    Name = "Apacher Server"
    Type = var.private_server ? "private" : "public"
  }
}

# Associate the NAT Gateway Route with a new Route Table to the new created Private Subnet 
resource "aws_route_table" "rt" {
  count  = var.private_server ? 1 : 0
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(data.aws_nat_gateway.default.*.id, count.index)
  }

  tags = {
    Name = "Apacher Server"
    Type = var.private_server ? "private" : "public"
  }
}
resource "aws_route_table_association" "rt-subnet" {
  count          = var.private_server ? 1 : 0
  subnet_id      = element(aws_subnet.created.*.id, count.index)
  route_table_id = element(aws_route_table.rt.*.id, count.index)
}

