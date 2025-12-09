# -----------------------------------------------------------------------
# Create default aws config resources for sub account
# -----------------------------------------------------------------------
module "default_aws_config" {
  source = "git::https://git.alteryx.com/futurama/bender/aws/shared-data-plane/tf-modules/aws-config.git?ref=v1.0.9"

  providers = {
    aws = aws.dpaccount
  }
}

resource "aws_ebs_encryption_by_default" "enabled" {
  enabled  = true
  provider = aws.dpaccount
}

resource "aws_iam_account_alias" "alias" {
  account_alias = replace(local.account_name, ".", "-")
  provider      = aws.dpaccount
}