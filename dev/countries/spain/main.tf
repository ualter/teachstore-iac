provider "aws" {
  region  = var.aws_region
}

#### Do it Here everything that could be generic, that is, necessary and used for all Applications 
#
# Generic VPC, Subnets, SG, etc.
# Example:
#   A generic VPC could be generated here (with all its characteristics) and passed as a parameter Vpc.Id to the Applications Modules
#


### Installing Applications, using their own modules  (their specific resources: EKS, BeanStalk, etc.)
################################################  Teachstore 
module "teachstore" {
  source                     = "./teachstore"
  aws_region                 = var.aws_region
  organization               = var.organization
  unit                       = var.unit
  environment                = var.environment
}

