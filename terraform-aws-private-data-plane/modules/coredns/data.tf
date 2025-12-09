
data "aws_subnets" "selected" {
  filter {
    name   = "tag:${var.subnet_tag.key}"
    values = [var.subnet_tag.value]
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:${var.vpc_tag.key}"
    values = [var.vpc_tag.value]
  }
}

// filter / sanitize input instances_types into available instance_types for the currrent region
data "aws_ec2_instance_types" "coredns" {
  filter {
    name   = "instance-type"
    values = var.COREDNS_AWS_AUTOSCALING.instance_types
  }
}


data "aws_ami_ids" "coredns" {
  provider   = aws.css
  name_regex = format("^%s%s", var.COREDNS_AWS_AMI_NAME_PREFIX_REGEX, local.AMI_VERSION_REGEX)
  owners     = ["self"]
}

data "aws_ami" "coredns" {
  provider   = aws.css
  for_each   = toset(local.COREDNS_CSS_AMIS)
  name_regex = var.COREDNS_AWS_AMI_NAME_PREFIX_REGEX
  # lowers and uppers css
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "image-id"
    values = [each.value]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ami" "selected_coredns_ami" {
  provider = aws.css
  # lowers and uppers css
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "image-id"
    values = [local.COREDNS_SELECTED_AMI]
  }
}
data "aws_vpc" "vpc_resolver_ip" {
  id = data.aws_vpc.selected.id
}

locals {
  vpc_resolver_ip = cidrhost(data.aws_vpc.vpc_resolver_ip.cidr_block, 2)
}
