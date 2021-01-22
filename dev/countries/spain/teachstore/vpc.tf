data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = "${local.name}-vpc"
  cidr                 = local.vpc_cidr_block
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = local.vpc_private_subnets
  public_subnets       = local.vpc_public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.teachstore_cluster_name}" = "shared"
     Enviroment                                 = var.environment
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.teachstore_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
     Enviroment                                 = var.environment
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.teachstore_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
     Enviroment                                 = var.environment
  }
}
