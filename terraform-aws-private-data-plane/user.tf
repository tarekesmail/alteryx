locals {
  policy_trusted_user_assume_aws_principals = concat(
    length(module.irsa[local.pdp_eks_role]) > 0 ? [module.irsa[local.pdp_eks_role].iam_role_arn] : [],
    ["arn:aws:iam::${local.account_id}:role/${local.pdp_eks_role}"],
    try([module.emr.serverless.jobRuntimeRoleArn], [])
  )
}

data "aws_iam_policy_document" "policy_trusted_user_assume" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = coalescelist(
        concat(var.AWS_DATAPLANE_EMR_SERVERLESS_TRUSTED_AWS_ACCOUNT_IDS, local.policy_trusted_user_assume_aws_principals)
      , ["*"])
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "role_trusted_user" {
  count              = local.k8s_option_enabled ? 1 : 0
  name               = local.trusted_user_role_name
  assume_role_policy = data.aws_iam_policy_document.policy_trusted_user_assume.json
}

resource "aws_iam_policy" "policy_assume_role" {
  count  = local.k8s_option_enabled ? 1 : 0
  name   = local.policy_assume_role
  policy = length(data.aws_iam_policy_document.policy_assume_role) > 0 ? data.aws_iam_policy_document.policy_assume_role[0].json : null
}

data "aws_iam_policy_document" "policy_assume_role" {
  count = length(aws_iam_role.role_trusted_user) > 0 ? 1 : 0
  statement {
    sid       = "VisualEditor0"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${local.account_id}:role/${aws_iam_role.role_trusted_user[0].name}"]
  }
}
