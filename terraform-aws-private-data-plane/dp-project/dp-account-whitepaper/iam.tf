locals {
  all_policies = [
    "base",
    "designer-cloud",
    "machine-learning",
    "cloud-execution",
    "cloud-execution-customization"
  ]
  dataplane_policies = {
    "cefdshared" = [
      "base",
      "cloud-execution",
      "cloud-execution-customization"
    ]
    "dedicated" = setsubtract(local.all_policies, ["cloud-execution-customization"])
  }

  # I thought setting this value to null would use the pdh_iam module default, but it ends up causing some errors. This can be improved in the future.
  # The other option would be to use disabled policies instead of enabled, that way the default is all policies are enabled but I think that is more confusing
  enabled_policies = try(local.dataplane_policies[var.DATAPLANE_TYPE], local.all_policies)
}

module "pdh_iam" {
  source = "../../modules/pdh-iam"

  enabled_policies = local.enabled_policies
  prefix           = var.account_prefix


  create_bridge_private_link_role = var.DATAPLANE_TYPE == "cefdshared"
  providers = {
    aws = aws.dpaccount
  }
}

resource "aws_iam_access_key" "aac_automation_sa_user_key" {
  user = module.pdh_iam.aac_automation_sa.name

  provider = aws.dpaccount
}

module "secrets-manager" {
  source = "lgallard/secrets-manager/aws"

  secrets = {
    aac_user_iam-keys = {
      description             = "aac_automation_sa user creds"
      recovery_window_in_days = 0
      secret_string = jsonencode(tomap({
        access_key = aws_iam_access_key.aac_automation_sa_user_key.id
        secret_key = aws_iam_access_key.aac_automation_sa_user_key.secret
      }))
    }
  }

  providers = {
    aws = aws.dpaccount
  }
}

# TODO: I can't find this value used anywhere
locals {
  IAM_SECRET_KEY_NAME = "${module.pdh_iam.aac_automation_sa.name}-access-key"
}