module "bridge-proxy-manager" {
  source   = "./modules/bridge-proxy-manager"
  for_each = local.ENABLE_BPM ? toset([local.account_name]) : toset([])

  tfworkspace = var.TF_CLOUD_WORKSPACE

  last_two_blocks_tfworkspace = local.append_unique_name
  name                        = "bridge-proxy-manager"

  accountid          = each.value
  region             = local.region
  teleport_proxy_uri = local.struct[local.structure].teleport_proxy_uri

  control_plane_name   = var.CONTROL_PLANE_NAME
  control_plane_region = var.CONTROL_PLANE_REGION
  control_plane_domain = var.CONTROL_PLANE_DOMAIN
  resource_name        = local.resource_name

  domain_prefix = split(".", var.CONTROL_PLANE_DOMAIN)[0]

  DATADOG_API_KEY = local.datadog_api_key["secret_key_value"]

  SEGMENTID = var.SEGMENTID

  TARGET_CLOUD = var.TARGET_CLOUD

  BPM_AWS_AMI_CURRENT_VERSION = local.BPM_AMI_VERSION
  BPM_AWS_AMI_SHARING_CREDS   = var.CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS
  BPM_AWS_AUTOSCALING         = var.BPM_AWS_AUTOSCALING

  ## allow coredns to access memorydb
  enable_memorydb            = local.enable_memorydb
  memorydb_security_group_id = try(module.memorydb[0].memorydb_security_group_id, null)
  core_dns_static_ip         = module.coredns[each.key].coredns_private_ip

  sentinelone_site_token = local.futurama_sentinelone_token

  tags    = merge(local.common_tags, tomap({ account_name = local.account_name }))
  tags_cp = merge(local.common_tags_cp, tomap({ account_name = local.account_name }))

  providers = {
    aws.css = aws.css
    aws     = aws
  }
}
