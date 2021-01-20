provider "aws" {
  region  = var.aws_region
}

################################################  Teachstore 
module "teachstore" {
  source                     = "./teachstore"
  aws_region                 = var.aws_region
  organization               = var.organization
  unit                       = var.unit
  environment                = var.environment
}

