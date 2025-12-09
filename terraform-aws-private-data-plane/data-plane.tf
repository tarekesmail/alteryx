locals {
  POD_SERVICE_ACCOUNT_NAME            = "job-pod-sa"
  RUNNER_SERVICE_ACCOUNT_NAME         = "job-runner-sa"
  RUNNER_SERVICE_ACCOUNT_NAMESPACE    = "default"
  CREDENTIAL_ENCRYPTION_SECRET_SM_KEY = "${local.resource_name}-${local.CREDENTIAL_ENCRYPTION_K8S_SECRET}"
  RUNNER_SERVICE_OAUTH_TOKEN          = "${local.resource_name}-job-runner-sa-oauth-token"
  CREDENTIAL_ENCRYPTION_K8S_SECRET    = "credential-encryption"
  CONTROL_PLANE_INFO_SECRET_NAME      = "${local.resource_name}-control-plane"

  # using a try() here could reduce the verbosity of this logic significantly
  # something like          = try(one(data.aws_secretmanager_secret_version.EKS_CONNECTION_TOKEN).secret_binary, "")
  POD_SERVICE_ACCOUNT_TOKEN = length(data.aws_secretsmanager_secret_version.EKS_CONNECTION_TOKEN) > 0 ? data.aws_secretsmanager_secret_version.EKS_CONNECTION_TOKEN[0].secret_binary : ""

  TLS = {
    algorithm = "RSA"
    rsa_bits  = 2048 # RSA key of size 2048
    name      = "tls_private_key"
  }

  EKS_CONNECTION = local.k8s_option_enabled ? {
    kubernetesConnectionInfo = {
      "jobExecution.kubernetes.master"                = local.CONTEXT.host
      "jobExecution.kubernetes.oauthToken"            = local.POD_SERVICE_ACCOUNT_TOKEN
      "jobExecution.kubernetes.clusterCACertificate"  = base64encode("${local.CONTEXT.cluster_ca_certificate}")
      "jobExecution.kubernetes.podServiceAccountName" = local.POD_SERVICE_ACCOUNT_NAME
    }
    envelopeEncryption = {
      "jobExecution.kubernetes.credentialEncryptionPublicKey"            = shell_script.tls_private_key_der[0].output["public_key.der"]
      "jobExecution.kubernetes.credentialEncryptionPrivateKeySecretName" = local.CREDENTIAL_ENCRYPTION_K8S_SECRET
    }
  } : {}

  CREDENTIAL_ENCRYPTION_SECRET = {
    "${local.CREDENTIAL_ENCRYPTION_SECRET_SM_KEY}" = {
      description = "data-plane credential-encryption private key"
      secret_key_value = {
        privateKey = length(shell_script.tls_private_key_der) > 0 ? shell_script.tls_private_key_der[0].output["private_key.der"] : ""
      }
    }
  }

  OAUTH_SECRET = {
    "${local.RUNNER_SERVICE_OAUTH_TOKEN}" = {
      description = "Job runner Oauth token secret"
      secret_key_value = {
      }
      tags = {
        managed-by = "external-secrets"
      }
    }
  }

  CONTROL_PLANE_INFO_SECRET = {
    "${local.CONTROL_PLANE_INFO_SECRET_NAME}" = {
      description = "Control plane info"
      secret_key_value = {
        name = local.any_option_enabled ? local.control_plane_name : ""
      }
    }
  }

  # Define CoreDNS secret only if ENABLE_COREDNS is true
  CORE_DNS_SECRET = local.ENABLE_COREDNS ? {
    "${local.resource_name}-CoreDNSClient" = {
      description = "CoreDNS Client Secret"
      secret_key_value = jsonencode({
        "coredns_private_ip" = module.coredns[local.account_name].coredns_private_ip,
        "vpc_resolver_ip"    = module.coredns[local.account_name].vpc_resolver_ip,
        "coredns_enabled"    = local.ENABLE_COREDNS
      })
    }
  } : {}
}

resource "tls_private_key" "credential_encryption2" {
  count     = local.k8s_option_enabled ? 1 : 0
  algorithm = local.TLS.algorithm
  rsa_bits  = local.TLS.rsa_bits
}
resource "shell_script" "tls_private_key_der" {
  count = local.k8s_option_enabled ? 1 : 0
  lifecycle_commands {
    create = file("${path.module}/scripts/create.sh")
    read   = file("${path.module}/scripts/read.sh")
    update = file("${path.module}/scripts/update.sh")
    delete = file("${path.module}/scripts/delete.sh")
  }

  environment = {
    KEY_NAME = local.TLS.name
  }
  sensitive_environment = {
    KEY_CONTENT = tls_private_key.credential_encryption2[0].private_key_pem_pkcs8
  }
}
resource "shell_script" "oauth_token_secret" {
  count = local.k8s_option_enabled ? 1 : 0
  lifecycle_commands {
    create = file("${path.module}/scripts/create-secret.sh")
    read   = file("${path.module}/scripts/read-secret.sh")
    delete = file("${path.module}/scripts/delete-secret.sh")
    update = file("${path.module}/scripts/update-secret.sh")
  }
  environment = {
    KEY_NAME = "${local.RUNNER_SERVICE_OAUTH_TOKEN}"
    REGION   = "${local.region}"
  }
  depends_on = [module.data_plane_private_helm, module.data-plane-register-private, module.data-plane-register-public]
}

resource "shell_script" "orphaned_resource_cleanup" {
  count = local.k8s_option_enabled ? 1 : 0
  lifecycle_commands {
    create = file("${path.module}/scripts/create-resources-cleanup.sh")
    read   = file("${path.module}/scripts/read-resources-cleanup.sh")
    delete = file("${path.module}/scripts/delete-resources-cleanup.sh")
    update = file("${path.module}/scripts/update-resources-cleanup.sh")
  }
  environment = {
    RESOURCE_NAME = "${local.resource_name}"
    REGION        = "${local.region}"
  }
}
