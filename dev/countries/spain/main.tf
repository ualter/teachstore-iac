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



module "bastion-ssm" {
    source            = "../../../modules/infrastructure/bastion-ssm"
    aws_region        = var.aws_region
    unit              = var.unit
    organization      = var.organization

    name              = "spain"
    environment       = var.environment
    vpc_id            = "vpc-4b594f22"
    public_subnets    = ["subnet-1d742066"]

    # Pass the subnet-id of your Private Subnet, if you have already one created and want to use it
    # IMPORTANT! This subnet must have a Route in its Route Table pointing the route "0.0.0.0/" to a 
    # NatGateway (that, in turn, sits in another Subnet, a public one)
    private_subnets   = ["subnet-026b34480a23089d4"]
    # Otherwise...
    # Pass blanks as subnet-id if you want that a new Private Subnet be created, where it will be install the EC2 Bastion
    # private_subnets   = ""


    # Pass the Elastic IP Id if you have one created (no-associated with any other resource) to be used in the NatGateway
    elastic_ip_id     = "eipalloc-044f6134dafd1d57f"
    # Otherwise...
    # Pass blanks as Elastic IP Id to be created a new oned
    #elastic_ip_id     = ""

    ec2_key_pair_name = "Administrator"

    ssh_forward_rules = [
      #"LocalForward 11433 ${module.rds.sql_endpoint}:${module.rds.sql_port}",
      #"LocalForward 44443 ${module.yourapp.alb_dns_name}:443"
      "LocalForward 11433 rdsmysql.endpoint.com:3306",
      "LocalForward 44443 activemq-ip:8441"
    ]
}

