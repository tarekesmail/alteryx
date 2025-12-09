moved {
  from = kubernetes_secret.pdp_argocd_bootstrap[0]
  to   = module.data-plane-register-public[0].kubernetes_secret.pdp_argocd_bootstrap
}

moved {
  from = kubernetes_secret.pdp_argocd_bootstrap_private[0]
  to   = module.data-plane-register-private[0].kubernetes_secret.pdp_argocd_bootstrap
}

# TODO: merge these back into one module
module "data-plane-register-public" {
  source = "./modules/data-plane-register/public"
  count  = local.k8s_option_enabled && !var.ENABLE_PRIVATE_K8S_API_ACCESS ? 1 : 0

  CLUSTER_REGISTRATION = {
    cloud                        = "aws"
    plane                        = "private-data"
    managementplaneName          = var.MANAGEMENT_PLANE_NAME
    controlplaneName             = var.CONTROL_PLANE_NAME
    dataplaneID                  = var.AWS_DATAPLANE_ID
    dataPlane                    = local.pdp_eks_name
    dataplaneRegion              = var.AWS_DATAPLANE_REGION
    domain_name                  = var.CONTROL_PLANE_DOMAIN
    subDomainName                = var.CONTROL_PLANE_DOMAIN
    registry                     = "us-docker.pkg.dev"
    aac_workspace_id             = var.SEGMENTID
    terraform_cloud_workspace_id = var.TF_CLOUD_WORKSPACE
    teleportAgentTrafficUri      = local.struct[local.structure].teleport_proxy_host
    resourceName                 = local.resource_name
    terraform_cloud_resource_id  = local.resource_name
    autoInsightsToggle           = local.auto_insights_toggle
    appBuilderToggle             = local.app_builder_toggle
    cloudExecToggle              = local.cloud_exec_toggle
    emrServerlessToggle          = local.emr_serverless_toggle
    designerCloudToggle          = local.designer_cloud_toggle
    automlToggle                 = local.automl_toggle
    subdomain_name               = local.subdomain_name
    resourceConductorToggle      = local.resource_conductor_toggle
    planeType                    = var.DATAPLANE_TYPE

  }

  dp_cluster_ca_cert    = local.CONTEXT.cluster_ca_certificate
  dp_cluster_host       = local.CONTEXT.host
  control_plane_name    = local.control_plane_name
  control_plane_region  = var.CONTROL_PLANE_REGION
  resource_name         = local.resource_name
  pdp_eks_name          = local.pdp_eks_name
  AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
  AWS_DATAPLANE_REGION  = var.AWS_DATAPLANE_REGION

  GOOGLE_CREDENTIALS = var.GCP_CSS_SECRET_KEY

  providers = {
    kubernetes.cp = kubernetes.cp
  }

  depends_on = [
    module.irsa,
    module.memorydb,
    shell_script.orphaned_resource_cleanup
  ]
}

module "data-plane-register-private" {
  source = "./modules/data-plane-register/private"
  count  = local.k8s_option_enabled && var.ENABLE_PRIVATE_K8S_API_ACCESS ? 1 : 0

  CLUSTER_REGISTRATION = {
    cloud                        = "aws"
    plane                        = "private-data"
    clusterNetworkingToggle      = "PRIVATE_CLUSTER"
    terraform_cloud_workspace_id = var.TF_CLOUD_WORKSPACE
    domain_name                  = var.CONTROL_PLANE_DOMAIN
    aac_workspace_id             = var.SEGMENTID
    subDomainName                = var.CONTROL_PLANE_DOMAIN
    dataPlane                    = local.pdp_eks_name
    dataplaneID                  = var.AWS_DATAPLANE_ID
    dataplaneRegion              = var.AWS_DATAPLANE_REGION
    controlplaneName             = var.CONTROL_PLANE_NAME
    registry                     = "us-docker.pkg.dev"
    managementplaneName          = var.MANAGEMENT_PLANE_NAME
    resourceName                 = local.resource_name
    teleportAgentTrafficUri      = local.struct[local.structure].teleport_proxy_host
    terraform_cloud_resource_id  = local.resource_name
    designerCloudToggle          = local.designer_cloud_toggle
    autoInsightsToggle           = local.auto_insights_toggle
    appBuilderToggle             = local.app_builder_toggle
    resourceConductorToggle      = local.resource_conductor_toggle
  }

  control_plane_name    = local.control_plane_name
  control_plane_region  = var.CONTROL_PLANE_REGION
  resource_name         = local.resource_name
  pdp_eks_name          = local.pdp_eks_name
  AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
  AWS_DATAPLANE_REGION  = var.AWS_DATAPLANE_REGION

  GOOGLE_CREDENTIALS = var.GCP_CSS_SECRET_KEY

  providers = {
    kubernetes.cp = kubernetes.cp
  }

  depends_on = [
    module.irsa,
    module.memorydb,
    shell_script.orphaned_resource_cleanup
  ]
}
