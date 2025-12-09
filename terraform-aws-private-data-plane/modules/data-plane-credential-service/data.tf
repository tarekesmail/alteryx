data "aws_iam_policy_document" "credential_service_secrets_manager_policy" {
  statement {
    sid    = "AllowCMSSecretManagerAccess"
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:TagResource",
      "secretsmanager:UntagResource",
      "secretsmanager:BatchGetSecretValue",
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:UpdateSecret",
      "secretsmanager:PutSecretValue"
    ]
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "credential_service_kms_key_policy" {
  statement {
    sid    = "AllowCMSKmsKeyPolicy"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [local.cms_key_arn]
  }
}

data "aws_iam_policy_document" "credential_service_role_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_url}:sub"
      values   = ["system:serviceaccount:credential:credential-pod-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      type        = "Federated"
      identifiers = [var.eks_oidc_provider_arn]
    }
  }
}

data "google_secret_manager_secret_version_access" "cms_pingone_clientid" {
  project = var.control_plane
  secret  = "cms-aws-pingone-clientId"
}

data "aws_caller_identity" "current" {}