


### Outputs EKS
#output "teachstore_eks_cluster_name" {
#  description = "EKS Cluster Name"
#  value       = module.teachstore.eks_cluster_name
#}
#
#output "teachstore_eks_cluster_endpoint" {
#  description = "Endpoint for EKS control plane."
#  value       = module.teachstore.eks_cluster_endpoint
#}
#
#output "teachstore_eks_cluster_kubeconfig" {
#  description = "Endpoint for EKS control plane."
#  value       = module.teachstore.eks_cluster_kubeconfig
#}
#
#output "teachstore_eks_config_map_aws_auth" {
#  description = "A kubernetes configuration to authenticate to this EKS cluster."
#  value       = module.teachstore.eks_config_map_aws_auth
#}

output "bastion_instance_id" {
  value = module.bastion-ssm.bastion_instance_id
}