locals {
  COREDNS_CSS_AMIS = try(data.aws_ami_ids.coredns.ids, [])

  COREDNS_SHARABLE_AMIS = [for image_id in local.COREDNS_CSS_AMIS : { image_id = image_id, account_id = var.accountid }]

  AMI_VERSION_REGEX = "(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?"

  # create augmented map { version => image_id } with additional entry "latest" pointing to last iamge_id by creation date
  COREDNS_AMIS_IMAGES_MAP = merge(try(tomap({ latest = local.COREDNS_CSS_AMIS[0] }), {}), { for ami in data.aws_ami.coredns : replace(ami.name, var.COREDNS_AWS_AMI_NAME_PREFIX_REGEX, "") => ami.image_id })

  # find by version or latest. If version or latest returns value. force hard error otherwise.
  COREDNS_SELECTED_AMI = lookup(local.COREDNS_AMIS_IMAGES_MAP, var.COREDNS_AWS_AMI_CURRENT_VERSION, "VERSION NOT FOUND! THIS IS A STOP ERROR MESSAGE AS IS A BUG AND REQUIRES SUPERVISION.")
}

module "coredns_ami" {
  source       = "../data-plane-aws-ami-sharing"
  count        = var.COREDNS_AWS_AMI_SHARING_CREDS != null ? 1 : 0
  sharing_list = [{ image_id = local.COREDNS_SELECTED_AMI, account_id = var.accountid }]
  providers = {
    aws = aws.css
  }
}