
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
data "aws_ec2_instance_types" "starayx" {
  filter {
    name   = "instance-type"
    values = var.STARAYX_AWS_AUTOSCALING.instance_types
  }
}

# data "pingone_environment" "starayx" {
#   name = "starayx"
# }

data "aws_ami_ids" "starayx" {
  provider   = aws.css
  name_regex = format("^%s%s", var.STARAYX_AWS_AMI_NAME_PREFIX_REGEX, local.AMI_VERSION_REGEX)
  owners     = ["self"]
}

data "aws_ami" "starayx" {
  provider   = aws.css
  for_each   = toset(local.STARAYX_CSS_AMIS)
  name_regex = var.STARAYX_AWS_AMI_NAME_PREFIX_REGEX
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

data "aws_ami" "selected_starayx_ami" {
  provider = aws.css
  # lowers and uppers css
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "image-id"
    values = [local.STARAYX_SELECTED_AMI]
  }
}
