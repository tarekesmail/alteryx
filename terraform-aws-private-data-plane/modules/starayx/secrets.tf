
locals {

  STARAYX_SECRETS_MANAGER_SECRETS = {

    "${var.resource_name}-starayx-registration-pingone-config" = {
      description      = "pingone integration : ${var.resource_name}-${var.name}"
      secret_key_value = local.pingone_merged_config
    }

    "${var.resource_name}-eks-cluster-ca" = {
      description      = "EKS cluster CA"
      secret_key_value = var.cluster_ca_cert
    }

    "${var.resource_name}-starayx-wg-private-key" = {
      description   = "starayx wireguard private key/binary secret"
      secret_string = " "
    }

    "${var.resource_name}-starayx-auth-pingone-config" = {
      description      = "pingone : ${var.resource_name}-${var.name}-auth"
      secret_key_value = local.pingone_config_starayx_auth
    }

    // more secrets
    // ...

  }

}

module "secrets" {
  source  = "lgallard/secrets-manager/aws"
  version = "0.6.1"

  tags = local.TAGS

  secrets = merge(local.STARAYX_SECRETS_MANAGER_SECRETS, var.secrets)

  recovery_window_in_days = 0

}
