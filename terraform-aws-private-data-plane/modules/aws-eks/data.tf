data "aws_canonical_user_id" "current" {}

data "aws_subnets" "control" {
  filter {
    name   = format("tag:%s", var.eks_control_tag.tagKey)
    values = var.eks_control_tag.tagValues
  }
}

data "aws_eks_cluster_auth" "selected" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}