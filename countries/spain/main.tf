#terraform {
#  required_providers {
#    aws = {
#      version = "~> 3.22"
#      source = "hashicorp/aws"
#    }
#  }
#}

provider "aws" {
  region  = var.aws_region
}

locals {
  cluster_name   = "teachstore-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}


/*
################################################  App1
module "networking-app1" {
  source             = "../../infrastructure/networking"
  name               = "app1"
  organization       = var.organization
  unit               = var.unit
  vpc_cidr_block     = local.vpc_cidr_block
}

module "app1" {
  source                        = "./app1"
  aws_region                    = var.aws_region
  ec2_key_name                  = var.ec2_key_name
  organization                  = var.organization
  unit                          = var.unit
  public_subnet_ids             = module.networking-app1.public_subnet_ids
  vpc_id                        = module.networking-app1.vpc_id
}
*/


################################################  Teachstore 
module "networking-teachstore" {
  source                     = "../../infrastructure/networking"
  name                       = "teachstore"
  organization               = var.organization
  unit                       = var.unit
  vpc_cidr_block             = "10.0.0.0/16"
  public_subnet_cidr_block   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidr_block  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  tags_vpc     = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
  tags_public_subnet = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
  tags_private_subnet = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

// AQUI
/*module "eks-teachstore" {
}*/

