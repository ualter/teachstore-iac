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
    ec2_key_pair_name = "Administrator"
    instance_type     = "t3.nano"
    vpc_id            = "vpc-4b594f22"
    public_subnets    = ["subnet-1d742066"]

    #
    # PRIVATE SUBNET where it will be created the EC2 Bastion
    # =======================================================
    # Inform the subnet-id of your Private Subnet, in case you have already one created and you want to use it
    # IMPORTANT! This subnet must have a Route in its Route Table pointing route "0.0.0.0/" to a NAT Gateway
    private_subnets   = ["subnet-026b34480a23089d4"]
    # Otherwise...
    # Pass blanks as subnet-id if you want that a new Private Subnet be created 
    # private_subnets   = ""


    # Pass the Elastic IP Id, if you have one created (not associated with any other resource) free to be used in the NAT Gateway
    elastic_ip_id     = "eipalloc-044f6134dafd1d57f"
    # Otherwise...
    # Pass blanks as Elastic IP Id to be created a new one
    #elastic_ip_id     = ""

    ssh_forward_rules = [
      #"LocalForward 11433 ${module.rds.sql_endpoint}:${module.rds.sql_port}",
      #"LocalForward 44443 ${module.yourapp.alb_dns_name}:443"
      "LocalForward 11433 rdsmysql.endpoint.com:3306",
      "LocalForward 44443 activemq-ip:8441"
    ]
}

