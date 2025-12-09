
locals {

  TELEPORT_SECRETS_MANAGER_SECRETS = {

    "${var.resource_name}-${var.name}-k8s-endpoint" = {
      description      = "tcp k8s endpoint"
      secret_key_value = local.tcp_k8s_endpoint
    }

    // more secrets
    // ...

  }

}

module "secrets" {
  source  = "lgallard/secrets-manager/aws"
  version = "0.6.1"

  tags = local.TAGS

  secrets = merge(local.TELEPORT_SECRETS_MANAGER_SECRETS, var.secrets)

  recovery_window_in_days = 0

}
