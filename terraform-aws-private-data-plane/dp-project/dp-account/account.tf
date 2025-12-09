
locals {
  # this defines naming policy
  account_prefixes = {
    cefdshared = "cefdsdp"
    dedicated  = "ddp"
  }
  account_prefix = try(local.account_prefixes[var.DATAPLANE_TYPE], var.DATAPLANE_TYPE)
  # modified_tf_workspace is last 2 blocks of the UUID
  modified_tf_workspace = join("-", slice(tolist(split("-", var.TF_CLOUD_WORKSPACE)), max(length(split("-", var.TF_CLOUD_WORKSPACE)) - 2, 0), length(split("-", var.TF_CLOUD_WORKSPACE))))
  account_name          = format("%s-%s", local.account_prefix, local.modified_tf_workspace)
  account_email         = "ayxsaas+futurama-${local.account_name}@alteryx.com"
  parent_id             = local.struct[local.structure].parent_id
}

module "dp_account" {
  source    = "git::https://git.alteryx.com/futurama/bender/aws/shared-data-plane/tf-modules/organization_account.git?ref=v1.2.2"
  name      = local.account_name
  email     = local.account_email
  parent_id = local.parent_id
  tags      = local.effective_tags

  providers = {
    aws = aws.presidio_root
  }
}

resource "aws_ssm_parameter" "account_id" {
  name  = "/organization/${local.account_prefix}_account/${local.account_name}/account_id"
  type  = "String"
  value = module.dp_account.id
}

resource "aws_lambda_invocation" "terminate_default_vpc" {
  function_name = "default_vpc_terminator"

  input = <<JSON
{
  "account":  "${module.dp_account.id}",
  "dryrun": "False"
}
JSON
}

# AWS Region Enablement for CEFDSDP accounts
resource "aws_account_region" "cefdsdp_regions" {
  for_each = var.DATAPLANE_TYPE == "cefdshared" ? toset([
    "ap-east-1",  # Hong Kong
    "me-south-1", # Bahrain
  ]) : []

  account_id  = module.dp_account.id
  region_name = each.value
  enabled     = true

  provider = aws.presidio_root

  depends_on = [module.dp_account]
}