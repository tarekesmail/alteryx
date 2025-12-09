
resource "aws_s3_bucket" "logging" {
  bucket        = local.s3_logging_bucket_name
  force_destroy = true
  tags          = local.common_tags
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = [
    "s3:PutObject"]
    principals {
      type = "Service"
      identifiers = [
      "delivery.logs.amazonaws.com"]
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/*"
    ]
  }
  statement {
    actions = [
    "s3:PutObject"]
    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com",
        "cloudtrail.amazonaws.com"
      ]
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
      "bucket-owner-full-control"]
    }
  }
  statement {
    actions = [
    "s3:GetBucketAcl"]
    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com",
        "cloudtrail.amazonaws.com"
      ]
    }
    resources = [
    "arn:aws:s3:::${aws_s3_bucket.logging.bucket}"]
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {

  bucket = aws_s3_bucket.logging.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.logging.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
  bucket     = aws_s3_bucket.logging.id

  access_control_policy {
    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "WRITE"
    }


    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  depends_on = [aws_s3_bucket.logging]
  bucket     = aws_s3_bucket.logging.id

  rule {
    id     = "7_days_expiration_all_objects"
    status = "Enabled"
    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  depends_on = [aws_s3_bucket.logging]
  bucket     = aws_s3_bucket.logging.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging_bucket" {
  depends_on              = [aws_s3_bucket.logging]
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true


}