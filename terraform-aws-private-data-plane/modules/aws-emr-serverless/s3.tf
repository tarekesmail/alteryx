
resource "aws_s3_bucket" "emr_logs" {
  # THe intention is that a bucket is always created
  count         = var.bucket_id != null ? 1 : 0
  bucket        = local.SERVERLESS_BUCKET_NAME
  tags          = var.tags
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "emr_logs" {
  count  = var.bucket_id != null ? 1 : 0
  bucket = aws_s3_bucket.emr_logs[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "emr_logs" {
  count                   = var.bucket_id != null ? 1 : 0
  bucket                  = aws_s3_bucket.emr_logs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "emr_logs_policy" {
  count = var.bucket_id != null ? 1 : 0
  statement {
    sid = "AllowEMRRolesS3Access"

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.job_launch.arn,
        aws_iam_role.job_runtime.arn,
      ]
    }

    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.emr_logs[0].arn,
      "${aws_s3_bucket.emr_logs[0].arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "emr_logs" {
  count  = var.bucket_id != null ? 1 : 0
  bucket = aws_s3_bucket.emr_logs[0].id
  policy = data.aws_iam_policy_document.emr_logs_policy[0].json

  lifecycle {
    create_before_destroy = true
  }
}
