locals {
  secrets = merge(
    local.credential_transfer_apis_auth_config,
    local.vault_configuration
  )

  oidc_url = replace(var.eks_oidc_provider_url, "https://", "")


  credential_transfer_apis_auth_config = {
    "${var.resource_name}-credential-transfer-apis-auth-config" = {
      description = "credential transfer apis pingone client id"
      secret_key_value = jsonencode({
        client_id = data.google_secret_manager_secret_version_access.cms_pingone_clientid.secret_data
        api_url   = "https://auth.pingone.com/${var.pingone_environment_id}"
      })
    }
  }

  vault_configuration = {
    "${var.resource_name}-vault-configuration" = {
      description = "cms vault configuration"
      secret_key_value = jsonencode({
        vault_type      = "AWS_SECRETS_MANAGER"
        auth_type       = "FEDERATED"
        connection_info = "{ \"kms_key_arn\": \"${local.cms_key_arn}\", \"region\": \"${var.region}\" }"
      })
    }
  }

  cms_key_arn = !var.is_pdp ? aws_kms_key.credential_service_kms[0].arn : var.cms_key_arn

}