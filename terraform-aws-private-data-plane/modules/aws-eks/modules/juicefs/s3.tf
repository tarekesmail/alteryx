resource "aws_iam_role_policy_attachment" "juicefs_s3_cluster" {
  policy_arn = aws_iam_policy.juicefs_s3.arn
  role       = var.cluster_iam_role_name
}

resource "aws_iam_role_policy_attachment" "juicefs_s3" {
  for_each   = var.eks_managed_node_groups
  policy_arn = aws_iam_policy.juicefs_s3.arn
  role       = each.value.iam_role_name
}

resource "aws_iam_policy" "juicefs_s3" {
  name_prefix = "${var.resource_name}-juicefs-s3"
  description = "JuiceFS S3 Access for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.juicefs_s3.json
  tags = merge(var.common_tags, {
    tf-module = "eks"
  })
}

data "aws_iam_policy_document" "juicefs_s3" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "${var.juicefs_s3_arn}",
      "${var.juicefs_s3_arn}/*"
    ]

    effect = "Allow"
  }
}
