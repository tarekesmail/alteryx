module "eks_blue" {
  source            = "./modules/aws-eks"
  count             = local.k8s_option_enabled ? 1 : 0
  vpc_id            = local.data_plane_vpc_id
  region            = data.aws_region.current.name
  starayx_allow_sg  = aws_security_group.allow_starayx_to_eks[0].id
  teleport_allow_sg = aws_security_group.teleport_agent[0].id

  account_id = data.aws_caller_identity.current.id

  common_tags             = local.common_labels
  color                   = "blue"
  cluster_name            = local.pdp_eks_name
  eks_config              = merge(local.eks_config, var.eks_config)
  eks_managed_node_groups = local.eks_managed_node_groups

  eks_managed_node_group_defaults = local.eks_managed_node_group_defaults

  PRIVATE_EKS_API_ACCESS = var.ENABLE_PRIVATE_K8S_API_ACCESS

  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY

  AWS_ACCESS_KEY_ID = var.AWS_ACCESS_KEY_ID

  region_instance_map = var.region_instance_map

  # The ARN string is used in a data source so a simple solution is to provide some dummy value
  juicefs_s3_arn = local.enable_juicefs ? one(aws_s3_bucket.juicefs).arn : "juicefs_not_enabled"
  # We want to use this flag within the eks_blue module too
  enable_juicefs = local.enable_juicefs

  memorydb_security_group_id = one(module.memorydb[*].memorydb_security_group_id)
  enable_memorydb            = local.enable_memorydb

  is_lowers = var.FUTURAMA_STRUCTURE == "lowers"

  node_subnet_ids = data.aws_subnets.node.ids
  node_subnet     = data.aws_subnet.this

  resource_name = local.resource_name
  providers = {
    kubernetes = kubernetes.blue
  }
  #Terraform destroys in reverse order of creation. We need this dependency to run the pv_ebs_cleanup after the EKS is deleted and all ebs are unattached.
  #If we add the dependency on pv_ebs_cleanup the script runs before the eks_blue module is deleted
  depends_on = [shell_script.pv_ebs_cleanup[0]]
}

moved {
  from = aws_autoscaling_group_tag.cluster_autoscaler_label_tags
  to   = module.eks_blue[0].module.autoscaling_group_tags.aws_autoscaling_group_tag.cluster_autoscaler_label_tags
}

resource "shell_script" "pv_ebs_cleanup" {
  count = local.k8s_option_enabled ? 1 : 0
  lifecycle_commands {
    create = file("${path.module}/scripts/create-pv-ebs-cleanup.sh")
    read   = file("${path.module}/scripts/read-pv-ebs-cleanup.sh")
    delete = file("${path.module}/scripts/delete-pv-ebs-cleanup.sh")
    update = file("${path.module}/scripts/update-pv-ebs-cleanup.sh")
  }
  environment = {
    REGION = "${local.region}"
  }
}