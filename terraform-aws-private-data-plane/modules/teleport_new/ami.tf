locals {
  TELEPORT_CSS_AMIS = try(data.aws_ami_ids.teleport.ids, [])

  TELEPORT_SHARABLE_AMIS = [for image_id in local.TELEPORT_CSS_AMIS : { image_id = image_id, account_id = var.accountid }]

  AMI_VERSION_REGEX = "(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?"

  # create augmented map { version => image_id } with additional entry "latest" pointing to last iamge_id by creation date
  TELEPORT_AMIS_IMAGES_MAP = merge(try(tomap({ latest = local.TELEPORT_CSS_AMIS[0] }), {}), { for ami in data.aws_ami.teleport : replace(ami.name, var.TELEPORT_AWS_AMI_NAME_PREFIX_REGEX, "") => ami.image_id })

  # find by version or latest. If version or latest returns value. force hard error otherwise.
  TELEPORT_SELECTED_AMI = lookup(local.TELEPORT_AMIS_IMAGES_MAP, var.TELEPORT_AWS_AMI_CURRENT_VERSION, "VERSION NO FOUND! THIS IS A STOP ERROR MESSAGE AS IS A BUG AND REQUIRES SUPERVISION.")
}


// TODO: perhaps rename upstream module to a more generic name as we are reusing it now for teleport and not exclusive to compat mode
module "teleport_ami" {
  source       = "../data-plane-aws-ami-sharing"
  count        = var.TELEPORT_AWS_AMI_SHARING_CREDS != null ? 1 : 0
  sharing_list = [{ image_id = local.TELEPORT_SELECTED_AMI, account_id = var.accountid }]
  providers = {
    aws = aws.css
  }
}
