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

module "networking-app1" {
  source             = "../../infrastructure/networking"
  name               = "app1-vpc"
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


/*module "networking-teachstore" {
  source             = "../../infrastructure/networking"
  name               = "teachstore-vpc"
  organization       = var.organization
  unit               = var.unit
  vpc_cidr_block     = local.vpc_cidr_block
}*/


