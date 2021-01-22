# Docs: 
# https://registry.terraform.io/browse/modules?provider=aws
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.18"
  subnets         = var.vpc_private_subnets

  tags = {
    Module       = "terraform-aws-eks"
    Unit         = var.unit
    Organization = var.organization
    Name         = var.name
    Enviroment   = var.environment
  }

  vpc_id = var.vpc_id

  worker_groups = var.worker_groups
}



data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}