
# secrets manager and iam_eks locals
locals {
  pdp_eks_role = "${local.resource_name}-cluster-role"

  ROLES = {

    "${local.resource_name}-argocd-external-secrets" = {

      prefix = local.resource_name

      namespaces = ["kube-system"]

      policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "terraform0",
      "Effect": "Allow",
      "Action": [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
      ],
      "Resource": [
          "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:${local.resource_name}-*",
          "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:upwind-sensor-client-*",
          "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:juicefs_config-*",
          "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:pact-key-*"          
      ]
    },
    {
      "Sid": "terraform1",
      "Effect": "Allow",
      "Action": [
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecret",
          "secretsmanager:TagResource"
      ],
      "Resource": "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:${local.resource_name}-job-runner-sa-oauth-token-*"
    }
  ]
}
EOF
    }


    "${local.pdp_eks_role}" = {

      k8sServiceAccount = "*"

      namespaces = [
        "automl-job-namespace",
        "dataservice-namespace",
        "photon-job-namespace",
        "convert-job-namespace",
        "data-system-job-namespace",
        "file-system-job-namespace",
        "filewriter-job-namespace"
      ]

      policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "terraform0",
      "Effect": "Allow",
      "Action": [
          "sts:AssumeRole"
      ],
      "Resource": "*"
    }
  ]
}
EOF
    }


  }
}

# This module depends on the secrets_manager module because we must make sure the role 
# ${local.resource_name}-argocd-external-secrets is deleted before the 
# ${local.resource_name}-job-runner-sa-oauth-token secret so that this secret cannot be recreated
module "irsa" {
  source               = "./modules/irsa"
  for_each             = local.ROLES
  enabled              = local.k8s_option_enabled
  role_name            = each.key
  role_name_prefix     = lookup(each.value, "role_name_prefix", local.resource_name)
  max_session_duration = lookup(each.value, "max_session_duration", 3600)
  policy               = lookup(each.value, "policy", "")
  account_id           = data.aws_caller_identity.current.account_id
  partition            = data.aws_partition.current.partition

  # this is created whenever an option with K8s is enabled...
  # almost certainly do not need this conditional - should probably use try() insetad
  oidc_issuer = length(module.eks_blue) > 0 ? module.eks_blue[0].oidc_provider_arn : ""

  # use k8sServiceAccount value when set. Defaults to role_name otherwise
  # if value is wildcard .. use it
  cluster_service_accounts = lookup(each.value, "k8sServiceAccount", each.key) == "*" ? [lookup(each.value, "k8sServiceAccount", each.key)] : formatlist("%s:%s", lookup(each.value, "namespaces", []), lookup(each.value, "k8sServiceAccount", each.key))
  tags                     = merge(lookup(each.value, "tags", {}), local.common_tags)
  depends_on = [
    module.eks_blue, # TODO: should be okay to remove this
    module.secrets_manager
  ]
}
