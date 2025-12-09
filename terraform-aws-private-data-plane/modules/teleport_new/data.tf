
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
data "aws_ec2_instance_types" "teleport" {
  filter {
    name   = "instance-type"
    values = var.TELEPORT_AWS_AUTOSCALING.instance_types
  }
}

# data "pingone_environment" "teleport" {
#   name = "teleport"
# }

data "aws_ami_ids" "teleport" {
  provider       = aws.css
  name_regex     = format("^%s%s", var.TELEPORT_AWS_AMI_NAME_PREFIX_REGEX, local.AMI_VERSION_REGEX)
  owners         = ["self"]
  sort_ascending = true
}

data "aws_ami" "teleport" {
  provider   = aws.css
  for_each   = toset(local.TELEPORT_CSS_AMIS)
  name_regex = var.TELEPORT_AWS_AMI_NAME_PREFIX_REGEX
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

data "aws_ami" "selected_teleport_ami" {
  provider = aws.css
  # lowers and uppers css
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "image-id"
    values = [local.TELEPORT_SELECTED_AMI]
  }
}
