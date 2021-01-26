
resource "aws_subnet" "created" {
  count      = local.subnet_bastion == "" ? 1 : 0
  vpc_id     = var.vpc_id
  cidr_block = "172.31.128.0/20"   # TODO: pass as variable

  tags = {
    Name         = "${var.environment}-bastion"
    Unit         = var.unit
    Organization = var.organization
    Enviroment   = var.environment
  }
}