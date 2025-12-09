resource "aws_iam_policy" "credential_service_secrets_manager_policy" {
  name   = "${var.resource_name}-credential-service-secrets-manager-policy"
  policy = data.aws_iam_policy_document.credential_service_secrets_manager_policy.json
  tags   = var.tags
}

resource "aws_iam_policy" "credential_service_kms_key_policy" {
  name   = "${var.resource_name}-credential-service-kms-key-policy"
  policy = data.aws_iam_policy_document.credential_service_kms_key_policy.json
  tags   = var.tags
}

resource "aws_iam_role" "cms_iam_role" {
  name               = "${var.resource_name}-credential-service-role"
  assume_role_policy = data.aws_iam_policy_document.credential_service_role_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachments_exclusive" "cms_iam_role" {
  role_name = aws_iam_role.cms_iam_role.name
  policy_arns = [
    aws_iam_policy.credential_service_kms_key_policy.arn,
    aws_iam_policy.credential_service_secrets_manager_policy.arn
  ]
}

resource "aws_iam_role_policy_attachment" "cms_iam_role_attach_kms_key_policy" {
  role       = aws_iam_role.cms_iam_role.name
  policy_arn = aws_iam_policy.credential_service_kms_key_policy.arn
}

resource "aws_iam_role_policy_attachment" "cms_iam_role_secrets_manager_policy" {
  role       = aws_iam_role.cms_iam_role.name
  policy_arn = aws_iam_policy.credential_service_secrets_manager_policy.arn
}

resource "aws_kms_key" "credential_service_kms" {
  count                   = !var.is_pdp ? 1 : 0
  description             = "KMS for DDP credential service"
  deletion_window_in_days = 10
  tags                    = var.tags
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "key-policy-1",
    "Statement" : [
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.cms_iam_role.name}"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${data.aws_caller_identity.current.arn}"
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:RotateKeyOnDemand",
          "kms:ScheduleKeyDeletion"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_kms_alias" "credential_service_kms_alias" {
  count         = !var.is_pdp ? 1 : 0
  name          = "alias/${var.resource_name}-cs-vault-key"
  target_key_id = aws_kms_key.credential_service_kms[0].key_id
}