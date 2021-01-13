output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = local.teachstore_cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks-teachstore.cluster_endpoint
}

output "eks_cluster_kubeconfig" {
  description = "Endpoint for EKS control plane."
  value       = module.eks-teachstore.kubectl_config
}

output "eks_config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks-teachstore.config_map_aws_auth
}