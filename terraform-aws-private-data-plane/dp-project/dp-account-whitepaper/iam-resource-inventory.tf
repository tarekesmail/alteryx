# This is not a whitepaper requirement, but this role needs to be created in all Alteryx-owned AWS accounts 
# and needs the dpaccount provider

# This role is used by IT for automated cloud asset inventory.
# See https://alteryx.atlassian.net/browse/TCIA-4896

module "resource_inventory_role" {
  source = "git::https://git.alteryx.com/futurama/bender/aws/tf-modules/resource-inventory-role.git?ref=v0.1"

  tags         = local.effective_tags
  account_name = local.account_name

  providers = {
    aws = aws.dpaccount
  }
}