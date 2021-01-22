provider "aws" {
  region  = var.aws_region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}


locals {
  teachstore_cluster_name = "teachstore-eks-${random_string.suffix.result}"
}

################################################  Teachstore 
module "eks-teachstore" {
  source                     = "../../../../modules/infrastructure/containers-eks"
  environment                = var.environment
  name                       = "teachstore"
  organization               = var.organization
  unit                       = var.unit
  cluster_name               = local.teachstore_cluster_name
  vpc_cidr_block             = "10.0.0.0/16"
  vpc_public_subnets         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vpc_private_subnets        = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

