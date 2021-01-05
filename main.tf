terraform {
  required_providers {
    aws = {
      version = "~> 3.22"
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
      bucket = "iac-terraform-state-ujr"
      region = "eu-west-3"
  }
}

provider "aws" {
    alias = "eu-west-3"
    region = "eu-west-3"
}

#module "roles" {
#  source = "./infrastructure/roles"
#}
#
#module "users" {
#  source = "./infrastructure/users"
#}

# Paris AWS Region
module "spain" {
  source = "./countries/spain"

  aws_region                    = var.aws_regions["paris"]
  ec2_key_name                  = var.ec2_key_name

  organization                  = "spain"
  unit                          = "accountability"
  #user_names                    = module.users.user_names
}