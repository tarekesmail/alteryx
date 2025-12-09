
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

data "confluent_environment" "environment_name" {
  count        = var.CONFLUENT_KAFKA_ENABLED ? 1 : 0
  display_name = "futurama-${var.FUTURAMA_STRUCTURE}"
}

data "confluent_kafka_cluster" "control_plane_cluster" {
  count        = var.CONFLUENT_KAFKA_ENABLED ? 1 : 0
  display_name = var.control_plane_name
  environment {
    id = one(data.confluent_environment.environment_name).id
  }
}

data "google_secret_manager_secret_version_access" "kafka" {
  for_each = var.CONFLUENT_KAFKA_ENABLED ? toset(local.GOOGLE_SECRET_MANAGER_CONTROL_PLANE_KAFKA_SECRETS) : toset([])
  project  = var.control_plane_name
  secret   = each.value
}

data "aws_caller_identity" "current" {}

data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

data "aws_vpc" "vpc_resolver_ip" {
  id = data.aws_vpc.selected.id
}

locals {
  vpc_resolver_ip = cidrhost(data.aws_vpc.vpc_resolver_ip.cidr_block, 2)
}
