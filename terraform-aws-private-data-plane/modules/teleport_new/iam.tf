
resource "aws_iam_instance_profile" "teleport" {
  name = "${var.resource_name}-${var.name}-service-instance-profile-role"
  role = aws_iam_role.teleport.name
  tags = local.TAGS
  lifecycle {
    create_before_destroy = false
  }
}

data "aws_iam_policy_document" "teleport_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "teleport" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:UpdateSecret",
      "secretsmanager:TagResource",
      "secretsmanager:UnTagResource",
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
      "secretsmanager:GetSecretValue",
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
      "secretsmanager:DescribeSecret",
    ]

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


resource "aws_iam_role" "teleport" {
  name               = "${var.resource_name}-${var.name}-service-instance-role"
  assume_role_policy = data.aws_iam_policy_document.teleport_assume_role.json

  inline_policy {
    name   = "secrets-manager-access"
    policy = data.aws_iam_policy_document.teleport.json
  }

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  #  tags = local.TAGS

  lifecycle {
    create_before_destroy = false
  }
}

