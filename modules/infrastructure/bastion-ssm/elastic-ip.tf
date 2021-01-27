
resource "aws_eip" "nat_eip" {
  count      = var.elastic_ip_id == "" ? 1 : 0  
  vpc        = true
  depends_on = [data.aws_internet_gateway.default]

  tags = {
    Name         = "${var.environment}-bastion-eip"
    Unit         = var.unit
    Organization = var.organization
    Enviroment   = var.environment
  }
}
