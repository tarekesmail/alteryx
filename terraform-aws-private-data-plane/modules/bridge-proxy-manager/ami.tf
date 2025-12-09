locals {
  BPM_CSS_AMIS = try(data.aws_ami_ids.bridge-proxy-manager.ids, [])

  BPM_SHARABLE_AMIS = [for image_id in local.BPM_CSS_AMIS : { image_id = image_id, account_id = var.accountid }]

  AMI_VERSION_REGEX = "(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?"

  # create augmented map { version => image_id } with additional entry "latest" pointing to last iamge_id by creation date
  BPM_AMIS_IMAGES_MAP = merge(try(tomap({ latest = local.BPM_CSS_AMIS[0] }), {}), { for ami in data.aws_ami.bridge-proxy-manager : replace(ami.name, var.BPM_AWS_AMI_NAME_PREFIX_REGEX, "") => ami.image_id })

  # find by version or latest. If version or latest returns value. force hard error otherwise.
  BPM_SELECTED_AMI = lookup(local.BPM_AMIS_IMAGES_MAP, var.BPM_AWS_AMI_CURRENT_VERSION, "VERSION NOT FOUND! THIS IS A STOP ERROR MESSAGE AS IS A BUG AND REQUIRES SUPERVISION.")
}

module "bridge_proxy_manager_ami" {
  source       = "../data-plane-aws-ami-sharing"
  count        = var.BPM_AWS_AMI_SHARING_CREDS != null ? 1 : 0
  sharing_list = [{ image_id = local.BPM_SELECTED_AMI, account_id = var.accountid }]
  providers = {
    aws = aws.css
  }
}