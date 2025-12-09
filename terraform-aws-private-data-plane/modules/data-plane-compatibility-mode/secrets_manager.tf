
module "data_plane_secrets_manager" {
  source  = "lgallard/secrets-manager/aws"
  version = "0.6.1"

  tags = local.TAGS

  secrets = merge(local.CLOUD_EXECUTION_SECRETS_MANAGER_SECRETS, var.secrets)

  recovery_window_in_days = 0

}
