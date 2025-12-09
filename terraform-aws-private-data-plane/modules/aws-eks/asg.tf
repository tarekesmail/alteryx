resource "aws_security_group_rule" "allow_eks_to_memorydb" {
  for_each                 = var.enable_memorydb ? local.eks_security_groups_id : {}
  type                     = "ingress"
  from_port                = 6378
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = var.memorydb_security_group_id
  source_security_group_id = each.value
  description              = "Allow traffic from EKS to MemoryDB - ${each.key}"
}

module "autoscaling_group_tags" {
  source = "./modules/asg-tags"

  eks_managed_node_groups = module.eks.eks_managed_node_groups
}