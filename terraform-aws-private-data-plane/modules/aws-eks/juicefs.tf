# TODO: this should be called from the root using outputs from eks module
module "juicefs" {
  count                   = var.enable_juicefs ? 1 : 0
  source                  = "./modules/juicefs"
  eks_managed_node_groups = module.eks.eks_managed_node_groups
  cluster_iam_role_name   = module.eks.cluster_iam_role_name
  juicefs_s3_arn          = var.juicefs_s3_arn
  cluster_name            = module.eks.cluster_name
  resource_name           = var.resource_name
}