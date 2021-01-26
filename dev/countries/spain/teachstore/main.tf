provider "aws" {
  region  = var.aws_region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  name                    = "teachstore"
  teachstore_cluster_name = "${local.name}-eks-${random_string.suffix.result}"
  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      #additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      #additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
  vpc_cidr_block             = "10.0.0.0/16"
  vpc_public_subnets         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vpc_private_subnets        = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# EKS Cluster
module "eks-teachstore" {
  source                     = "../../../../modules/infrastructure/containers-eks"
  region                     = var.region
  environment                = var.environment
  name                       = local.name
  organization               = var.organization
  unit                       = var.unit
  cluster_name               = local.teachstore_cluster_name
  worker_groups              = local.worker_groups
  vpc_id                     = module.vpc.vpc_id
  vpc_private_subnets        = module.vpc.private_subnets
}

