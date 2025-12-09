# -----------------------------------------------------------------------------
# UPWIND CLEANUP CONFIGURATIONS
# -----------------------------------------------------------------------------
# NOTE: These Upwind configurations are temporarily maintained for cleanup 
# purposes only. Upwind integration on AWS DDP has been deprecated, but these data sources
# and locals must remain active to properly remove existing Upwind resources
# from AWS accounts. These can be safely removed once all Upwind resources
# have been cleaned up across all environments.
# -----------------------------------------------------------------------------

data "gitlab_group_variable" "upwind_cloud_creds" {
  group = "futurama/bender/gcp"
  key   = "TF_VAR_upwind_cloud_creds"
}

data "gitlab_group_variable" "upwind_thirdparty_creds" {
  group = "futurama/bender/gcp"
  key   = "TF_VAR_upwind_thirdparty_creds"
}

data "http" "upwind_auth" {
  url    = "https://auth.upwind.io/oauth/token"
  method = "POST"
  request_headers = {
    Content-Type = "application/json"
  }

  request_body = jsonencode({
    "audience" : "https://integration.upwind.io",
    "client_id" : local.upwind_thirdparty_creds.clientID,
    "client_secret" : local.upwind_thirdparty_creds.clientSecret,
    "grant_type" : "client_credentials"
  })

  retry {
    attempts     = 3
    min_delay_ms = 5000
  }
}

locals {
  response     = jsondecode(data.http.upwind_auth.response_body)
  access_token = local.response["access_token"]

  environment_key         = var.FUTURAMA_STRUCTURE
  upwind_cloud_creds      = jsondecode(data.gitlab_group_variable.upwind_cloud_creds.value)[local.environment_key]
  upwind_thirdparty_creds = jsondecode(data.gitlab_group_variable.upwind_thirdparty_creds.value)[local.environment_key]
}


# -----------------------------------------------------------------------------
# 1) Cloud Connect (AWS)
#    - Links AWS account to Upwind (initial credentials hook).
# -----------------------------------------------------------------------------
module "upwind_cloud_integration" {
  count                  = !local.is_pdp ? 1 : 0
  source                 = "git::https://git.alteryx.com/futurama/bender/aws/tf-modules/upwind/upwind-aws-cloudconnect.git?ref=v0.2.4"
  upwind_client_id       = local.upwind_cloud_creds.clientID
  upwind_client_secret   = local.upwind_cloud_creds.clientSecret
  upwind_organization_id = local.upwind_cloud_creds.organizationID
}