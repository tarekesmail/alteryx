locals {
  account_region           = var.AWS_DATAPLANE_REGION
  core_region              = "us-east-1"
  presidio_role            = local.struct[local.structure].presidio_role
  presidio_root_account_id = local.struct[local.structure].presidio_root_account_id
  organization             = local.struct[local.structure].organization
  structure                = var.FUTURAMA_STRUCTURE
  common_tags = {
    owner       = "futurama"
    department  = "SaaS"
    plane       = "data"
    geolocation = "us"
    cloud       = "aws"
    dptype      = "dedicated"
  }
  effective_tags = merge(local.common_tags, local.struct[local.structure].tags)
  sso_groups     = local.struct[local.structure].sso_groups

  struct = {
    lowers = {
      presidio_root_account_id = "687401715307"
      parent_id                = "ou-nmix-czb3mcuu"
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
      parent_id                = "ou-iq1w-eg90z2fq"
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
