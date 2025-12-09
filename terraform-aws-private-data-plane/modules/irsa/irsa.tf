
module "iam_eks_role_policy" {
  source = "./iam-policy"
  count  = var.enabled ? 1 : 0
  # for_each = local.ROLES
  name = var.role_name #format("%s-%s", local.account_name, each.key)

  description = "" #null
  # path = format("/%s", local.account_name)
  # defalts to a deny policy when not set
  policy = var.policy != "" ? var.policy : <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "terraform0sts",
      "Effect": "Allow",
      "Action": "sts:*",
      "Resource": "*"
    }
  ]
}
EOF

  tags = var.tags

}


module "irsa" {
  source                     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                    = "~> 5.0"
  count                      = var.enabled ? 1 : 0
  role_name                  = var.role_name
  assume_role_condition_test = "StringLike"
  oidc_providers = {
    one = {
      provider_arn               = var.oidc_issuer
      namespace_service_accounts = var.cluster_service_accounts
    }
  }
  role_policy_arns = {
    (var.role_name) = length(module.iam_eks_role_policy) > 0 ? (module.iam_eks_role_policy[0].arn) : null
  }
  tags = var.tags
}

moved {
  from = module.iam_eks_role_policy
  to   = module.iam_eks_role_policy[0]
}

moved {
  from = module.irsa
  to   = module.irsa[0]
}