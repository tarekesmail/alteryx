output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_id" {
  description = "The ID of your local Amazon EKS cluster on the AWS Outpost. This attribute isn't available for an AWS EKS cluster on AWS cloud."
  value       = module.eks.cluster_id
}

# why does cluster_name output 'id' attribute instead of 'name'
output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.id
}

output "oidc_issuer" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster"
  value       = module.eks.cluster_primary_security_group_id
}

output "eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = module.eks.eks_managed_node_groups
}

output "cluster_access_token" {
  description = "Token to use to authenticate with the cluster"
  value       = data.aws_eks_cluster_auth.selected.token
}

#TODO keep this one since in data_plane module is incorrect naming
output "oicd_issuer" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider (legacy naming)"
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if enabled"
  value       = module.eks.oidc_provider_arn
}

output "CONTEXT" {
  description = "EKS cluster context information"
  value       = local.CONTEXT
}

output "eks_subnet_node_ids" {
  description = "List of subnet IDs where the EKS node groups are deployed"
  value       = var.node_subnet_ids
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = module.eks.node_security_group_id
}

output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster"
  value       = module.eks.cluster_security_group_id
}

output "aws_security_group_node_sg_rule_id" {
  description = "Security group rule ID allowing EKS nodes to access MemoryDB"
  value       = aws_security_group_rule.allow_eks_to_memorydb
}