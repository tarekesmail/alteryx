
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "job_launch_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = var.allowed_role_arns
    }
  }
}

resource "aws_iam_role" "job_launch" {
  name               = local.SERVERLESS_ROLE_APPS_JOBS
  assume_role_policy = data.aws_iam_policy_document.job_launch_assume.json
  tags               = merge({ Name = local.SERVERLESS_ROLE_APPS_JOBS }, var.tags)
  depends_on         = [aws_s3_bucket.emr_logs]
}

data "aws_iam_policy_document" "job_launch" {
  statement {
    sid = "EMRServerlessAccess"
    actions = [
      "emr-serverless:CreateApplication",
      "emr-serverless:UpdateApplication",
      "emr-serverless:DeleteApplication",
      "emr-serverless:ListApplications",
      "emr-serverless:GetApplication",
      "emr-serverless:StartApplication",
      "emr-serverless:StopApplication",
      "emr-serverless:StartJobRun",
      "emr-serverless:CancelJobRun",
      "emr-serverless:ListJobRuns",
      "emr-serverless:GetJobRun",
    ]
    resources = ["*"]
  }
  statement {
    sid       = "AllowNetworkInterfaceCreationViaEMRServerless"
    actions   = ["ec2:CreateNetworkInterface"]
    resources = ["arn:aws:ec2:*:*:network-interface/*", "arn:aws:ec2:*:*:security-group/*", "arn:aws:ec2:*:*:subnet/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:CalledViaLast"
      values   = ["ops.emr-serverless.amazonaws.com"]
    }
  }
  statement {
    sid    = "AllowEMRServerlessServiceLinkedRoleCreation"
    effect = "Allow"
    actions = [
      "iam:CreateServiceLinkedRole",
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ops.emr-serverless.amazonaws.com/AWSServiceRoleForAmazonEMRServerless"]
  }
  statement {
    sid       = "AllowPassingRuntimeRole"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.job_runtime.arn]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["emr-serverless.amazonaws.com"]
    }
  }
  statement {
    sid     = "S3ResourceBucketAccess"
    actions = ["s3:PutObject", "s3:GetObject", "s3:ListBucket", "s3:DeleteObject"]
    resources = [
      "arn:aws:s3:::${local.SERVERLESS_BUCKET_NAME}",
      "arn:aws:s3:::${local.SERVERLESS_BUCKET_NAME}/*",
    ]
  }
  statement {
    sid       = "KMSAccess"
    actions   = ["kms:Decrypt", "kms:Encrypt"]
    resources = ["arn:aws:kms:*:*:key/*"]
  }
}

resource "aws_iam_role_policy" "job_launch" {
  name   = aws_iam_role.job_launch.id
  role   = aws_iam_role.job_launch.id
  policy = data.aws_iam_policy_document.job_launch.json
}

