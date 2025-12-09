
locals {
  # account specific
  structure                = var.AWS_FUTURAMA_STRUCTURE
  account_name             = var.AWS_ACCOUNT_NAME
  account_region           = var.AWS_ACCOUNT_REGION
  account_id               = var.AWS_ACCOUNT_ID
  core_region              = "us-east-1"
  parent_id                = local.struct[local.structure].parent_id
  presidio_role            = local.struct[local.structure].presidio_role
  presidio_root_account_id = local.struct[local.structure].presidio_root_account_id
  organization             = local.struct[local.structure].organization
  sso_groups               = local.struct[local.structure].sso_groups
  common_tags = {
    owner       = "futurama"
    department  = "SaaS"
    plane       = "data"
    geolocation = "us"
    cloud       = "aws"
  }
  effective_tags     = merge(local.common_tags, local.struct[local.structure].tags)
  primary_vpc_cidr   = "10.60.0.0/21"
  secondary_vpc_cidr = "10.70.0.0/18"

  struct = {
    lowers = {
      presidio_root_account_id = "687401715307"
      parent_id                = "ou-nmix-tvv28cuq"
      presidio_role            = "alteryx4-cross-account-role"
      organization             = "lower"
      tags = {
        costalloc = "253"
        structure = "lowers"
      }
      sso_groups = {
        billing = [
          "sg_aws-saml-futurama-lower-shared-dp-billing",
        ]
        audit = [
          "asg_aws-saml-futurama-readonly",
          "asg_aws-saml-futurama-lower-readonly"
        ]
        security = [
          "asg_aws-saml-futurama-security",
          "asg_aws-saml-futurama-lower-security"
        ]
        admin = [
          "asg_aws-saml-futurama-admin",
          "asg_aws-saml-futurama-lower-admins",
          "sg_aws-saml-futurama-lower-shared-dp-admins"
        ]
      }
    }
    uppers = {
      presidio_root_account_id = "765819002789"
      parent_id                = "changeMe" # need to double check this
      presidio_role            = "alteryx5-cross-account-role"
      organization             = "upper"
      tags = {
        costalloc = "401"
        structure = "uppers"
      }
      sso_groups = {
        billing = [
          "sg_aws-saml-futurama-upper-shared-dp-billing",
        ]
        audit = [
          "asg_aws-saml-futurama-readonly",
          "asg_aws-saml-futurama-upper-readonly"
        ]
        security = [
          "asg_aws-saml-futurama-security",
          "asg_aws-saml-futurama-upper-security"
        ]
        admin = [
          "asg_aws-saml-futurama-admin",
          "asg_aws-saml-futurama-upper-admins"
        ]
      }
    }
  }

}