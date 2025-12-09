

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}


locals {
  partition = data.aws_partition.current.partition

  s3_logging_bucket_name = "${var.region}-${var.cluster_name}-logs"

  common_tags = merge(var.common_tags, {
    tf-module = "eks"
  })


  CONTEXT = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.selected.token

  }


  common_node_group = { for subnet in var.node_subnet_ids :
    "common-${split("-", var.node_subnet[subnet].availability_zone)[2]}" => {
      name = "common-${split("-", var.node_subnet[subnet].availability_zone)[2]}"
      labels = {
        "pool-name" = "common",
        "type"      = "common"
      }
      instance_types = var.is_lowers ? local.commmon_instance_types_lowers : local.selected_instance_types.common
      min_size       = 1
      desired_size   = 1
      max_size       = 3
      subnet_ids     = [subnet]
    }
  }


  eks_managed_node_groups = merge(var.eks_managed_node_groups, local.common_node_group)

  commmon_instance_types_lowers = ["t3a.xlarge", "t3.xlarge"]
  selected_instance_types       = lookup(var.region_instance_map, var.region, lookup(var.region_instance_map, "default"))

  enable_memorydb = var.memorydb_security_group_id == null ? false : true
  memorydb_port   = "6378"
  eks_security_groups_id = {
    node_sg    = module.eks.node_security_group_id
    primary_sg = module.eks.cluster_primary_security_group_id
    cluster_sg = module.eks.cluster_security_group_id
  }
}
