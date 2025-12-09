module "teleport_new" {
  count  = local.k8s_option_enabled && var.ENABLE_PRIVATE_K8S_API_ACCESS ? 1 : 0
  source = "./modules/teleport_new"

  tfworkspace = var.TF_CLOUD_WORKSPACE

  last_two_blocks_tfworkspace = local.append_unique_name

  accountid          = local.account_name
  region             = local.region
  teleport_proxy_uri = local.struct[local.structure].teleport_proxy_uri

  control_plane_name   = var.CONTROL_PLANE_NAME
  control_plane_region = var.CONTROL_PLANE_REGION
  control_plane_domain = var.CONTROL_PLANE_DOMAIN
  cluster_name         = one(module.eks_blue).cluster_name
  resource_name        = local.resource_name
  cluster_ca_cert      = local.CONTEXT.cluster_ca_certificate
  cluster_endpoint     = local.CONTEXT.host

  domain_prefix = split(".", var.CONTROL_PLANE_DOMAIN)[0]

  DATADOG_API_KEY = local.datadog_api_key["secret_key_value"]

  SEGMENTID = var.SEGMENTID

  TARGET_CLOUD = var.TARGET_CLOUD

  TELEPORT_AWS_AMI_CURRENT_VERSION = var.TELEPORT_AWS_AMI_CURRENT_VERSION
  TELEPORT_AWS_AMI_SHARING_CREDS   = var.CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS
  TELEPORT_AWS_AUTOSCALING         = var.TELEPORT_AWS_AUTOSCALING


  eks_security_group_id = aws_security_group.teleport_agent[0].id




  tags = merge(local.common_tags, tomap({ account_name = local.account_name }))

  providers = {
    aws.css = aws.css
    aws     = aws
  }
}

