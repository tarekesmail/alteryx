
resource "aws_iam_instance_profile" "compatibility_mode" {
  name = local.cefd_resource_name
  role = aws_iam_role.compatibility_mode.name
  tags = local.TAGS

}

data "aws_iam_policy_document" "compatibility_mode_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "cloudwatch.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# allow datadog to collect tags if enabled https://github.com/DataDog/datadog-agent/blob/main/pkg/config/config_template.yaml#L365
data "aws_iam_policy_document" "compatibility_mode" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:TerminateInstances"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/autoscaling_groupName"
      values   = ["${aws_autoscaling_group.compatibility_mode.name}"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "autoscaling:DetachInstances",
      "autoscaling:SetDesiredCapacity"
    ]
    resources = [
      "arn:aws:autoscaling:${var.region}:${var.account_name}:autoScalingGroup:*:autoScalingGroupName/${aws_autoscaling_group.compatibility_mode.name}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeImages"
    ]
    resources = ["*"]
  }

  # Secrets Manager restricted to a specific secret
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      "arn:aws:secretsmanager:*:${var.account_name}:secret:${var.resource_name}-*"
    ]
  }
}

resource "aws_iam_role" "compatibility_mode" {
  name               = local.cefd_resource_name
  assume_role_policy = data.aws_iam_policy_document.compatibility_mode_assume_role.json
  tags               = local.TAGS
}

resource "aws_iam_role_policy" "secret_manager_access" {
  name   = "${var.resource_name}-secrets-manager-access"
  role   = aws_iam_role.compatibility_mode.id
  policy = data.aws_iam_policy_document.compatibility_mode.json
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.compatibility_mode.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## TCIA-3959 additional container roles for compatibility mode

resource "aws_iam_role" "container_role" {
  count                = var.is_cefdshared ? 0 : 1
  name                 = "${var.resource_name}-cefd-container-role"
  assume_role_policy   = data.aws_iam_policy_document.container_role_assume_role_policy.json
  max_session_duration = 43200
  tags                 = local.TAGS
}

resource "aws_iam_role_policy" "container_service_access" {
  count  = var.is_cefdshared ? 0 : 1
  name   = "${var.resource_name}-container-service-access"
  role   = aws_iam_role.container_role[0].id
  policy = data.aws_iam_policy_document.container_service_access[0].json
}

data "aws_iam_policy_document" "container_role_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.compatibility_mode.arn]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "container_service_access" {
  count = var.is_cefdshared ? 0 : 1
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "kms:Decrypt",
      "dynamoDB:*",
      "s3:*"
    ]
    resources = ["*"]
  }
}

#Update the EC2 Instance Role to Assume the New Role
data "aws_iam_policy_document" "ec2_assume_container_role" {
  count = var.is_cefdshared ? 0 : 1
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [local.CONTAINER_ROLE_ARN]
  }
}

resource "aws_iam_role_policy" "ec2_assume_container_role_policy" {
  count  = var.is_cefdshared ? 0 : 1
  name   = "ec2-assume-container-role-policy"
  role   = aws_iam_role.compatibility_mode.id
  policy = data.aws_iam_policy_document.ec2_assume_container_role[0].json
}

# IAM Role for AutoScaling - TCUD 5209
resource "aws_iam_role" "autoscale_role" {
  name = "${var.resource_name}-cefd-autoscale-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  max_session_duration = 43200

  tags = local.TAGS
}

resource "aws_iam_role_policy_attachment" "autoscale_role_ec2_full_access" {
  role       = aws_iam_role.autoscale_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "autoscale_role_autoscaling_full_access" {
  role       = aws_iam_role.autoscale_role.name
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}

data "aws_iam_policy_document" "autoscale_secrets_access" {
  statement {
    sid    = "ReadSpecificSecret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${var.resource_name}-compatibility-mode-appsettings-*",
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${var.resource_name}-datadog-api-key-*"
    ]
  }

  statement {
    sid       = "ListAllSecrets"
    effect    = "Allow"
    actions   = ["secretsmanager:ListSecrets"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "autoscale_secrets_access" {
  name        = "${var.resource_name}-cefd-autoscale-secrets-access"
  description = "Least-privilege Secrets Manager access for ${aws_iam_role.autoscale_role.name}"
  policy      = data.aws_iam_policy_document.autoscale_secrets_access.json
}

resource "aws_iam_role_policy_attachment" "autoscale_role_secrets_manager_limited" {
  role       = aws_iam_role.autoscale_role.name
  policy_arn = aws_iam_policy.autoscale_secrets_access.arn
}

resource "aws_iam_role_policy_attachment" "autoscale_role_lambda_basic_execution" {
  role       = aws_iam_role.autoscale_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "s3_read_only_policy" {
  count = var.ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER ? 1 : 0

  statement {
    sid    = "S3ReadOnlyAccess"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      aws_s3_bucket.custom_drivers_storage[0].arn,
      "${aws_s3_bucket.custom_drivers_storage[0].arn}/*"
    ]
  }
}


# Create the S3 read-only policy
resource "aws_iam_policy" "s3_read_only_policy" {
  count = var.ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER ? 1 : 0

  name        = "${var.SEGMENTID}-read-only-policy"
  description = "Read-only access policy for S3 bucket alteryx-customizations-${var.SEGMENTID}"
  policy      = data.aws_iam_policy_document.s3_read_only_policy[0].json
}

# Attach the S3 read-only policy to the compatibility mode role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  count      = var.ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER ? 1 : 0
  depends_on = [aws_iam_role.compatibility_mode]

  role       = aws_iam_role.compatibility_mode.name
  policy_arn = aws_iam_policy.s3_read_only_policy[0].arn
}
