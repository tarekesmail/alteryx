locals {
  all_subnets = [
    "public",
    "private",
    "option",
    "eks_node",
    "eks_control"
  ]
  dataplane_subnets = {
    "cefdshared" = ["public", "option", "private"]
    "dedicated"  = local.all_subnets
  }
  enabled_subnets = try(local.dataplane_subnets[var.DATAPLANE_TYPE], local.all_subnets)
}

module "pdh_networking" {
  source = "git::https://git.alteryx.com/futurama/bender/aws/private-data-plane/tf-modules/pdh-networking.git?ref=v0.2.1"

  primary_vpc_cidr   = local.primary_vpc_cidr
  secondary_vpc_cidr = local.secondary_vpc_cidr
  account_region     = local.account_region
  enabled_subnets    = local.enabled_subnets

  providers = {
    aws.pdpaccount = aws.dpaccount
  }
}