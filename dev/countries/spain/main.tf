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
#module "teachstore" {
#  source                     = "./teachstore"
#  aws_region                 = var.aws_region
#  organization               = var.organization
#  unit                       = var.unit
#  environment                = var.environment
#}



module "bastion" {
    source            = "../../../modules/infrastructure/bastion-ssm"
    aws_region        = var.aws_region
    unit              = var.unit
    organization      = var.organization

    name              = "spain"
    environment       = var.environment
    vpc_id            = "vpc-4b594f22"
    public_subnets    = ["subnet-f4506d9d"]
    private_subnets   = ["subnet-026b34480a23089d4"]
    create_elastic_ip = false
    elastic_ip_id     = "eipalloc-044f6134dafd1d57f"
    ec2_key_pair_name = "Administrator"

    ssh_forward_rules = [
      #"LocalForward 11433 ${module.rds.sql_endpoint}:${module.rds.sql_port}",
      #"LocalForward 44443 ${module.yourapp.alb_dns_name}:443"
      "LocalForward 11433 rdsmysql.endpoint.com:3306",
      "LocalForward 44443 activemq-ip:8441"
    ]
}

