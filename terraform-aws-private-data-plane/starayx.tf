locals {
  ENABLE_STARAYX = local.k8s_option_enabled
}

module "starayx" {
  source   = "./modules/starayx"
  for_each = local.ENABLE_STARAYX ? toset([local.account_name]) : toset([])

  tfworkspace = var.TF_CLOUD_WORKSPACE

  last_two_blocks_tfworkspace = local.append_unique_name

  accountid          = each.value
  region             = local.region
  teleport_proxy_uri = local.struct[local.structure].teleport_proxy_uri

  control_plane_name   = var.CONTROL_PLANE_NAME
  control_plane_region = var.CONTROL_PLANE_REGION
  control_plane_domain = var.CONTROL_PLANE_DOMAIN
  cluster_name         = one(module.eks_blue).cluster_name
  resource_name        = local.resource_name
  cluster_ca_cert      = local.CONTEXT.cluster_ca_certificate
  cluster_endpoint     = local.CONTEXT.host

  domain_prefix                 = split(".", var.CONTROL_PLANE_DOMAIN)[0]
  starayx_registration_endpoint = data.terraform_remote_state.control_plane.outputs.starayx.wireguard.registration_endpoint
  sentinelone_site_token        = local.futurama_sentinelone_token

  DATADOG_API_KEY = local.datadog_api_key["secret_key_value"]

  SEGMENTID = var.SEGMENTID

  TARGET_CLOUD = var.TARGET_CLOUD

  STARAYX_AWS_AMI_CURRENT_VERSION = var.STARAYX_AWS_AMI_CURRENT_VERSION
  STARAYX_AWS_AMI_SHARING_CREDS   = var.CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS
  STARAYX_AWS_AUTOSCALING         = var.STARAYX_AWS_AUTOSCALING
  STARAYX_CONTROL_PLANE_IPS       = local.starayx_control_plane_ips
  STARAYX_PINGONE = {
    environment_id = var.PINGONE_WORKER_APPLICATION_ENVIRONMENTID
    apiURL         = "https://auth.pingone.com/${var.PINGONE_WORKER_APPLICATION_ENVIRONMENTID}"
  }
  allow_eks_traffic_sg_id = aws_security_group.allow_starayx_to_eks[0].id

  tags            = merge(local.common_tags, tomap({ account_name = local.account_name }))
  tags_cp         = merge(local.common_tags_cp, tomap({ account_name = local.account_name }))
  enable_memorydb = local.enable_memorydb
  ## allow starayx to access memorydb
  memorydb_security_group_id = local.enable_memorydb ? try(module.memorydb[0].memorydb_security_group_id, null) : null

  providers = {
    aws.css = aws.css
    aws     = aws
    pingone = pingone
  }
}

