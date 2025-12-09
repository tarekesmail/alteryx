module "teleport" {
  source                                  = "./modules/teleport"
  for_each                                = toset([local.account_name])
  teleport_windows_token                  = random_uuid.teleport_windows_token.result
  teleport_agent_base_ami                 = local.teleport_agent_base_ami
  teleport_cluster                        = local.struct[local.structure].teleport_cluster
  teleport_proxy_uri                      = local.struct[local.structure].teleport_proxy_uri
  account_name                            = each.value
  region                                  = local.region
  control_plane_name                      = local.control_plane_name
  SEGMENTID                               = var.SEGMENTID
  CLOUD_EXECUTION_AWS_AMI_CURRENT_VERSION = local.CLOUD_EXECUTION_VERSION
  CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS   = var.CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS
  resource_name                           = local.resource_name

  vpc_id = var.vpc_id

  TF_CLOUD_WORKSPACE   = var.TF_CLOUD_WORKSPACE
  CONTROL_PLANE_DOMAIN = var.CONTROL_PLANE_DOMAIN

  DISABLE_VPC_ENDPOINTS = true
  autoscaling           = var.CLOUD_EXECUTION_AWS_AUTOSCALING
  tags                  = merge(local.common_tags, tomap({ Name = local.account_name }))
  providers = {
    aws.css = aws.css
  }
  FUTURAMA_STRUCTURE = local.structure
}
