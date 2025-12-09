resource "random_uuid" "teleport_windows_token" {
  count = local.any_option_enabled ? 1 : 0
}

module "data_plane_private_helm" {
  source                  = "./modules/data-plane-private-helm"
  count                   = local.any_option_enabled ? 1 : 0
  private_data_plane_name = local.resource_name
  control_plane_name      = local.control_plane_name
  pdp_eks_name            = local.pdp_eks_name
  pdp_eks_region          = data.aws_region.current.name
  aws_access_key_id       = base64encode(var.AWS_ACCESS_KEY_ID)
  aws_secret_access_key   = base64encode(var.AWS_SECRET_ACCESS_KEY)
  resource_name           = local.resource_name
  eks                     = local.k8s_option_enabled
  bpm                     = local.ENABLE_BPM
  coredns                 = local.ENABLE_COREDNS

  segment_id = var.SEGMENTID

  argocd_bender_server = local.argocd_bender_server

  teleport_windows_token = random_uuid.teleport_windows_token[0].result
  cefd                   = var.ENABLE_CLOUD_EXECUTION
  aws_account_id         = data.aws_caller_identity.current.id

  depends_on = [
    module.irsa
  ]

  TF_CLOUD_WORKSPACE   = var.TF_CLOUD_WORKSPACE
  CONTROL_PLANE_DOMAIN = var.CONTROL_PLANE_DOMAIN

  providers = {
    helm.mp = helm.mp
  }
}
