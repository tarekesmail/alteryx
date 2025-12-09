resource "aws_s3_bucket" "juicefs" {
  count         = local.enable_juicefs ? 1 : 0
  bucket        = local.s3_juicefs_bucket_name
  force_destroy = true
  tags          = local.common_labels
}

resource "aws_s3_bucket_server_side_encryption_configuration" "juicefs" {
  count  = local.enable_juicefs ? 1 : 0
  bucket = aws_s3_bucket.juicefs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "juicefs" {
  count                   = local.enable_juicefs ? 1 : 0
  bucket                  = aws_s3_bucket.juicefs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# EKS node role ARNs to allow as principals
locals {
  # Only try to get node role ARNs if both juicefs and eks_blue are enabled
  eks_module_exists  = var.ENABLE_EMR_SERVERLESS || var.ENABLE_DC || var.ENABLE_AML || var.ENABLE_AUTO_INSIGHTS || var.ENABLE_APPBUILDER
  eks_node_role_arns = local.eks_module_exists ? [for ng in module.eks_blue[0].eks_managed_node_groups : ng.iam_role_arn] : []
}

# Bucket policy document that allows s3:* to the EKS node roles
data "aws_iam_policy_document" "juicefs_s3_bucket" {
  count = local.enable_juicefs && length(local.eks_node_role_arns) > 0 ? 1 : 0

  statement {
    sid     = "Statement1"
    effect  = "Allow"
    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = local.eks_node_role_arns
    }

    resources = [
      aws_s3_bucket.juicefs[0].arn,
      "${aws_s3_bucket.juicefs[0].arn}/*",
    ]
  }
}

# Attach the policy to the JuiceFS bucket
resource "aws_s3_bucket_policy" "juicefs" {
  count  = local.enable_juicefs && length(local.eks_node_role_arns) > 0 ? 1 : 0
  bucket = aws_s3_bucket.juicefs[0].id
  policy = data.aws_iam_policy_document.juicefs_s3_bucket[0].json
}
