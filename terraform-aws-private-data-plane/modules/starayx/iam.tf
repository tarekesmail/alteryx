
resource "aws_iam_instance_profile" "starayx" {
  name = "${var.resource_name}-${var.name}-service-instance-profile-role"
  role = aws_iam_role.starayx.name
  tags = local.TAGS
  lifecycle {
    create_before_destroy = false
  }
}

data "aws_iam_policy_document" "starayx_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "starayx" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:UpdateSecret",
      "secretsmanager:TagResource",
      "secretsmanager:UnTagResource",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "secretsmanager:ResourceTag/tfworkspace"
      values   = [var.tfworkspace]
    }

    resources = ["arn:aws:secretsmanager:*:${var.accountid}:secret:*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "eks:DescribeCluster",
      "eks:AccessKubernetesApi",
    ]
    resources = ["arn:aws:eks:${var.region}:${var.accountid}:cluster/${var.cluster_name}"]
  }
}


resource "aws_iam_role" "starayx" {
  name               = "${var.resource_name}-${var.name}-service-instance-role"
  assume_role_policy = data.aws_iam_policy_document.starayx_assume_role.json

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy" "secrets_manager_access" {
  name   = "${var.resource_name}-secrets-manager-access"
  role   = aws_iam_role.starayx.id
  policy = data.aws_iam_policy_document.starayx.json
}

resource "aws_iam_role_policy_attachments_exclusive" "starayx" {
  role_name   = aws_iam_role.starayx.name
  policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}