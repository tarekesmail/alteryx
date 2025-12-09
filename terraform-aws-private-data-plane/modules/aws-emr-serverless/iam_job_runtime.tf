
data "aws_iam_policy_document" "job_runtime_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["emr-serverless.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "job_runtime" {
  name               = local.SERVERLESS_ROLE_SPARK_EXE
  assume_role_policy = data.aws_iam_policy_document.job_runtime_assume.json
  tags               = merge({ Name = local.SERVERLESS_ROLE_SPARK_EXE }, var.tags)
  depends_on         = [aws_s3_bucket.emr_logs]
}

data "aws_iam_policy_document" "job_runtime" {
  statement {
    sid = "S3ResourceBucketAccess"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]
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
  statement {
    sid       = "STSAccessForAssumingCustomerXAccountRoles"
    actions   = ["sts:AssumeRole", "sts:TagSession"]
    resources = ["*"]
  }
  statement {
    sid       = "TrifactaPublicBucketAccess"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = concat(formatlist("arn:aws:s3:::%s", var.trifacta_public_buckets_names), formatlist("arn:aws:s3:::%s/*", var.trifacta_public_buckets_names))
  }
  statement {
    sid       = "ListAllBuckets"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "job_runtime" {
  name   = aws_iam_role.job_runtime.id
  role   = aws_iam_role.job_runtime.id
  policy = data.aws_iam_policy_document.job_runtime.json
}



