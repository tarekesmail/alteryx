
locals {
  # [cnotarianni] TODO: this value is temporarily being computed by Terraform during MVP + testing for cefdshared
  # This value should be computed by some service upstream to keep the complexity of the Terraform low, 
  # although which service and how has not been decided yet
  max_scaling_by_license_tier = {
    enterprise = 5
  }

  # look up the scaling value by license tier, default to max scaling var if license tier is not in map
  cloud_execution_max_scaling = local.is_cefdshared ? try(local.max_scaling_by_license_tier[var.LICENSE_TIER], var.CLOUD_EXECUTION_MAX_SCALING) : var.CLOUD_EXECUTION_MAX_SCALING
  worker_timeout_seconds      = local.is_cefdshared ? 3600 : 43200
}

module "compatibility_mode" {
  source   = "./modules/data-plane-compatibility-mode"
  for_each = var.ENABLE_CLOUD_EXECUTION ? toset([local.account_name]) : toset([])

  account_name                            = each.value
  region                                  = var.AWS_DATAPLANE_REGION
  control_plane_name                      = local.control_plane_name
  SEGMENTID                               = var.SEGMENTID
  CLOUD_EXECUTION_AWS_AMI_CURRENT_VERSION = local.CLOUD_EXECUTION_VERSION
  CLOUD_EXECUTION_ENGINE_VERSION          = var.CLOUD_EXECUTION_ENGINE_VERSION
  CLOUD_EXECUTION_MAX_SCALING             = local.cloud_execution_max_scaling
  CLOUD_EXECUTION_AUTOSCALING_VERSIONS    = var.CLOUD_EXECUTION_AUTOSCALING_VERSIONS
  CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS   = var.CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS
  ENABLE_COREDNS                          = local.ENABLE_COREDNS
  resource_name                           = local.resource_name
  TF_CLOUD_WORKSPACE                      = var.TF_CLOUD_WORKSPACE
  CONTROL_PLANE_DOMAIN                    = var.CONTROL_PLANE_DOMAIN
  DATAPLANE_TYPE                          = var.DATAPLANE_TYPE
  ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER     = var.ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER
  ENABLE_DCM_SERVICE                      = var.ENABLE_DCM_SERVICE
  DISABLE_VPC_ENDPOINTS                   = true
  FUTURAMA_STRUCTURE                      = local.structure
  TARGET_CLOUD                            = var.TARGET_CLOUD

  # TODO: this might not be used for anything right now
  license_tier   = var.LICENSE_TIER
  is_cefdshared  = local.is_cefdshared
  worker_timeout = local.worker_timeout_seconds

  tags = merge(local.common_tags, tomap({ Name = local.account_name }))

  providers = {
    aws.css = aws.css
  }
}
