module "coredns" {
  source   = "./modules/coredns"
  for_each = local.ENABLE_COREDNS ? toset([local.account_name]) : toset([])

  tfworkspace = var.TF_CLOUD_WORKSPACE

  last_two_blocks_tfworkspace = local.append_unique_name
  name                        = "coredns"

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

  COREDNS_AWS_AMI_CURRENT_VERSION = var.COREDNS_AWS_AMI_CURRENT_VERSION
  COREDNS_AWS_AMI_SHARING_CREDS   = var.CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS
  COREDNS_AWS_AUTOSCALING         = var.COREDNS_AWS_AUTOSCALING

  tags    = merge(local.common_tags, tomap({ account_name = local.account_name }))
  tags_cp = merge(local.common_tags_cp, tomap({ account_name = local.account_name }))

  ## redis info for coredns
  enable_memorydb = local.enable_memorydb
  redis_endpoint  = try(module.memorydb[0].redis_endpoint, null)
  redis_port      = try(module.memorydb[0].redis_port, null)
  redis_username  = try(module.memorydb[0].redis_username, null)
  redis_password  = try(module.memorydb[0].redis_password, null)

  ## allow coredns to access memorydb
  memorydb_security_group_id = try(module.memorydb[0].memorydb_security_group_id, null)

  sentinelone_site_token = local.futurama_sentinelone_token

  providers = {
    aws.css = aws.css
    aws     = aws
  }
}
