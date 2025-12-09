module "credential_mgmt_service" {
  count                  = local.k8s_option_enabled && (!local.is_pdp || var.AWS_KEY_ARN != "") && local.struct[local.structure].enable_credential_service_infra ? 1 : 0
  source                 = "./modules/data-plane-credential-service"
  region                 = var.AWS_DATAPLANE_REGION
  resource_name          = local.resource_name
  tags                   = local.common_labels
  cms_key_arn            = var.AWS_KEY_ARN
  eks_oidc_provider_arn  = module.eks_blue[0].oidc_provider_arn
  eks_oidc_provider_url  = module.eks_blue[0].oicd_issuer
  control_plane          = var.CONTROL_PLANE_NAME
  is_pdp                 = local.is_pdp
  pingone_environment_id = var.PINGONE_WORKER_APPLICATION_ENVIRONMENTID
}