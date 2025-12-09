locals {
  CLOUD_EXECUTION_CSS_AMIS = try(data.aws_ami_ids.compatibility_mode.ids, [])

  CLOUD_EXECUTION_SHARABLE_AMIS = [for image_id in local.CLOUD_EXECUTION_CSS_AMIS : { image_id = image_id, account_id = var.account_name }]

  AMI_VERSION_REGEX = "(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?"

  # create augmented map { version => image_id } with additional entry "latest" pointing to last image_id by creation date
  CLOUD_EXECUTION_AMIS_IMAGES_MAP = merge(try(tomap({ latest = local.CLOUD_EXECUTION_CSS_AMIS[0] }), {}), { for ami in data.aws_ami.compatibility_mode : replace(ami.name, var.CLOUD_EXECUTION_AWS_AMI_NAME_PREFIX_REGEX, "") => ami.image_id })

  # create augmented map { version => name } with additional entry "latest" pointing to last image_id by creation date
  CLOUD_EXECUTION_AMI_NAMES_MAP = merge(try(tomap({ latest = data.aws_ami.compatibility_mode_latest.name }), {}), { for ami in data.aws_ami.compatibility_mode : replace(ami.name, var.CLOUD_EXECUTION_AWS_AMI_NAME_PREFIX_REGEX, "") => ami.name })

  # find by version or latest. If version or latest returns value. force hard error otherwise.
  CLOUD_EXECUTION_SELECTED_AMI      = lookup(local.CLOUD_EXECUTION_AMIS_IMAGES_MAP, var.CLOUD_EXECUTION_AWS_AMI_CURRENT_VERSION, "VERSION NO FOUND! THIS IS A STOP ERROR MESSAGE AS IS A BUG AND REQUIRES SUPERVISION.")
  CLOUD_EXECUTION_SELECTED_AMI_NAME = lookup(local.CLOUD_EXECUTION_AMI_NAMES_MAP, var.CLOUD_EXECUTION_AWS_AMI_CURRENT_VERSION, "")
}

data "aws_ami_ids" "compatibility_mode" {
  owners     = ["self"]
  name_regex = format("^%s%s", var.CLOUD_EXECUTION_AWS_AMI_NAME_PREFIX_REGEX, local.AMI_VERSION_REGEX)
  provider   = aws.css
}

data "aws_ami" "compatibility_mode" {
  for_each   = toset(local.CLOUD_EXECUTION_CSS_AMIS)
  name_regex = var.CLOUD_EXECUTION_AWS_AMI_NAME_PREFIX_REGEX
  # lowers and uppers css
  owners      = ["self"]
  most_recent = true
  provider    = aws.css
  filter {
    name   = "image-id"
    values = [each.value]
  }
}

data "aws_ami" "compatibility_mode_latest" {
  name_regex = var.CLOUD_EXECUTION_AWS_AMI_NAME_PREFIX_REGEX
  # lowers and uppers css
  owners      = ["self"]
  most_recent = true
  provider    = aws.css
}

module "compatibility_mode_ami" {
  source       = "../data-plane-aws-ami-sharing"
  count        = var.CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS != null ? 1 : 0
  sharing_list = [{ image_id = local.CLOUD_EXECUTION_SELECTED_AMI, account_id = var.account_name }]
  providers = {
    aws = aws.css
  }
}
