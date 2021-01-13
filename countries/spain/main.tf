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
  tags_vpc     = {
    "Whatsover" = "shared"
  }
  tags_public_subnet = {
    "State" = "shared"
    "Status" = "1"
  }
  tags_private_subnet = {
    "State" = "shared"
    "Status" = "1"
  }
}
*/

locals {
  teachstore_cluster_name = "teachstore-eks-${random_string.suffix.result}"
}

################################################  Teachstore 
module "eks-teachstore" {
  source                     = "../../infrastructure/containers-eks"
  name                       = "teachstore"
  organization               = var.organization
  unit                       = var.unit
  cluster_name               = local.teachstore_cluster_name
  vpc_cidr_block             = "10.0.0.0/16"
  vpc_public_subnets         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vpc_private_subnets        = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

