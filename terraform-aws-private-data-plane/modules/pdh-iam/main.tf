terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.48.0"
    }
  }
}

locals {
  policies = {
    "AAC_Base_SA_Policy"               = "base",
    "AAC_DesignerCloud_SA_Policy"      = "designer-cloud",
    "AAC_MachineLearning_SA_Policy"    = "machine-learning",
    "AAC_CEFD_SA_Policy"               = "cloud-execution",
    "AAC_CEFD_Customization_SA_Policy" = "cloud-execution-customization"
    "AAC_AppBuilder_SA_Policy"         = "appbuilder"
    "AAC_AutoInsights_SA_Policy"       = "autoinsights"
  }

  enabled_policies = {
    for k, v in local.policies : k => v
    if contains(var.enabled_policies, v)
  }

}

resource "aws_iam_user" "aac_automation_sa" {
  name = var.aac_sa_name

  tags = {
    "AACResource" = "aac_iam_user"
  }
}

resource "aws_iam_user_policy_attachment" "aac_automation_sa" {
  for_each   = aws_iam_policy.this
  user       = aws_iam_user.aac_automation_sa.name
  policy_arn = each.value.arn
}

resource "aws_iam_policy" "this" {
  for_each    = local.enabled_policies
  name        = each.key
  path        = "/"
  description = "Grants access for AAC SA to configure resources for PDH"

  policy = file(format("${path.module}/policies/%s.json", each.value))

  tags = {
    "AACResource" = "aac_sa_custom_policy"
  }
}

resource "aws_iam_user_policy" "aac_automation_sa_inline_policy" {
  name = "aac-automation-sa-inline-${var.prefix}-policy"
  user = aws_iam_user.aac_automation_sa.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GetKeyPolicy",
          "kms:GetKeyRotationStatus",
          "kms:ListGrants",
          "kms:ListResourceTags",
          "kms:ListRetirableGrants",
          "kms:PutKeyPolicy",
          "kms:RetireGrant",
          "kms:RevokeGrant",
          "kms:ScheduleKeyDeletion",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:CreateAlias",
          "kms:DeleteAlias"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:kms:*:*:key/*",
          "arn:aws:kms:*:*:alias/*"
        ]
      },
      {
        Action = [
          "kms:ListAliases"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# ==========================
# Bridge Private Link pieces
# ==========================

data "aws_iam_policy_document" "bridge_client_private_link" {
  count = var.create_bridge_private_link_role ? 1 : 0

  statement {
    sid    = "AllowVPCEActions"
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcEndpointServices",
      "ec2:CreateVpcEndpoint",
      "ec2:CreateTags",
      "ec2:DescribePrefixLists",
      "ec2:DescribeNetworkInterfaces",
      "vpce:AllowMultiRegion",
      "ec2:DeleteVpcEndpoints",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "bridge_client_private_link" {
  count = var.create_bridge_private_link_role ? 1 : 0

  name   = "BridgeClientPrivateLinkPolicy-${var.prefix}"
  policy = data.aws_iam_policy_document.bridge_client_private_link[0].json

  tags = {
    "AACResource" = "aac_bridge_private_link_policy"
  }
}

data "aws_iam_policy_document" "bridge_client_private_link_assume_role" {
  count = var.create_bridge_private_link_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.aac_automation_sa.arn]
    }
  }
}

resource "aws_iam_role" "bridge_client_private_link" {
  count = var.create_bridge_private_link_role ? 1 : 0

  name               = "bridgeclientprivatelinkrole"
  assume_role_policy = data.aws_iam_policy_document.bridge_client_private_link_assume_role[0].json

  tags = {
    "AACResource" = "aac_bridge_private_link_role"
  }
}

resource "aws_iam_role_policy_attachment" "bridge_client_private_link" {
  count = var.create_bridge_private_link_role ? 1 : 0

  role       = aws_iam_role.bridge_client_private_link[0].name
  policy_arn = aws_iam_policy.bridge_client_private_link[0].arn
}