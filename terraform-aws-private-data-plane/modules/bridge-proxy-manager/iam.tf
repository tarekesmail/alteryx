resource "aws_iam_role" "bridge_proxy_manager_role" {
  name = "${local.full_name}-bpm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.TAGS
}

resource "aws_iam_role_policy" "secrets_manager_access" {
  name   = "${var.resource_name}-secrets-manager-access"
  role   = aws_iam_role.bridge_proxy_manager_role.id
  policy = data.aws_iam_policy_document.bpm_sm_access.json
}

data "aws_iam_policy_document" "bpm_sm_access" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "secretsmanager:ResourceTag/tfworkspace"
      values   = [var.tfworkspace]
    }

    resources = ["arn:aws:secretsmanager:*:${var.accountid}:secret:${var.resource_name}-*"]
  }
}


resource "aws_iam_instance_profile" "bridge_proxy_manager_profile" {
  name = "${local.full_name}-bpm-profile"
  role = aws_iam_role.bridge_proxy_manager_role.name
}
