# IaC - Infrastructure on AWS
## AWS SSM Bastion Server

Create an AWS SSM Bastion Server (Private)


Usage
```bash
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
    # IMPORTANT! This subnet must have a Route in its Route Table pointing route "0.0.0.0/0" to a NAT Gateway
    #private_subnets   = ["subnet-026b34480a23089d4"]
    # Otherwise...
    # Pass blanks as subnet-id if you want that a new Private Subnet be created, as well pass its CDIRs Block
    private_subnets   = [""]
    private_subnet_cidr_block = "172.31.128.0/20"


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
```

