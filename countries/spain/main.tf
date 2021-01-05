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
  vpc_cidr_block            = "10.33.0.0/16"
}

module "networking-teachstore" {
  source             = "../../infrastructure/networking"
  name               = "teachstore-vpc"
  organization       = var.organization
  unit               = var.unit
  vpc_cidr_block     = local.vpc_cidr_block
}


module "teachstore" {
  source                        = "./teachstore"
  aws_region                    = var.aws_region
  ec2_key_name                  = var.ec2_key_name
  organization                  = var.organization
  unit                          = var.unit
  public_subnet_ids             = module.networking-teachstore.public_subnet_ids
  vpc_id                        = module.networking-teachstore.vpc_id
}
