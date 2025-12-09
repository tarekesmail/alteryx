module "teleport" {
  count  = 0
  source = "./modules/teleport"

  FUTURAMA_STRUCTURE = var.FUTURAMA_STRUCTURE

  eks_cluster_name = one(module.eks_blue).cluster_name

  teleport_cluster        = local.struct[local.structure].teleport_cluster
  teleport_eks_enabled    = local.k8s_option_enabled
  teleport_eks_host       = try(replace(local.CONTEXT.host, "https://", ""), null)
  teleport_windows_token  = random_uuid.teleport_windows_token[0].result
  teleport_agent_base_ami = local.teleport_agent_base_ami
  teleport_proxy_uri      = local.struct[local.structure].teleport_proxy_uri
  teleport_min_size       = local.eks_api_access == "private" ? 1 : 0
  vpc_id                  = var.AWS_DATAPLANE_VPC_ID
  account_name            = local.account_name
  region                  = local.region
  control_plane_name      = local.control_plane_name
  resource_name           = local.resource_name
  SEGMENTID               = var.SEGMENTID
  TF_CLOUD_WORKSPACE      = var.TF_CLOUD_WORKSPACE
  CONTROL_PLANE_DOMAIN    = var.CONTROL_PLANE_DOMAIN
  eks_security_group_id   = aws_security_group.teleport_agent[0].id
}
