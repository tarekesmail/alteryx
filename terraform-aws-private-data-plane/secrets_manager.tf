data "google_secret_manager_secret_version" "pact-key" {
  secret  = "pact-key"
  project = local.control_plane_name
}

locals {
  # TODO: clean up this code

  # Conditional secrets inclusion only if any of EMR, AIDIN, DC, AML, or Auto Insights (eks related) are enabled
  eks_product_secrets = {
    "CREDENTIAL_ENCRYPTION_SECRET" = (local.k8s_option_enabled) ? local.CREDENTIAL_ENCRYPTION_SECRET : {},
    "PDP_GAR_SA_KEY"               = (local.k8s_option_enabled) ? local.PDP_GAR_SA_KEY : {},
    "OAUTH_SECRET"                 = (local.k8s_option_enabled) ? local.OAUTH_SECRET : {}
  }

  # Base secrets are always included when any of the CEfD, EMR, DC, or AML , CEFD options are enabled
  # Note: any CEfD specific secrets add here
  base_secrets = {
    "CONTROL_PLANE_INFO_SECRET" = (local.any_option_enabled) ? local.CONTROL_PLANE_INFO_SECRET : {}
    "KAFKA_SECRETS"             = (local.any_option_enabled) ? local.KAFKA_SECRETS : {}
    "PACT_KEY"                  = (local.any_option_enabled) ? local.PACT_KEY : {}
  }

  # Merge conditional and base secrets
  SECRET = merge(
    local.eks_product_secrets["CREDENTIAL_ENCRYPTION_SECRET"],
    local.eks_product_secrets["PDP_GAR_SA_KEY"],
    local.eks_product_secrets["OAUTH_SECRET"],
    local.base_secrets["CONTROL_PLANE_INFO_SECRET"],
    local.base_secrets["KAFKA_SECRETS"],
    local.base_secrets["PACT_KEY"],
    local.CORE_DNS_SECRET,
    #Include INPUT_SECRETS only when applicable with below logic to ensure consistent object types and avoid Terraform evaluation errors
    [
      for s in [local.INPUT_SECRETS] : s
      if local.any_option_enabled
    ]...
  )
}

module "secrets_manager" {
  source                  = "./modules/secrets_manager"
  secrets                 = local.SECRET
  recovery_window_in_days = 0
  tags                    = local.common_tags
}

