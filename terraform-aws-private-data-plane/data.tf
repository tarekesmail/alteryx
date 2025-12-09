data "terraform_remote_state" "control_plane" {
  backend = "gcs"
  config = {
    bucket = "futurama-common-tfstate"
    prefix = "control-plane/${local.structure}/${local.control_plane_name}"
  }
}

data "google_container_cluster" "mp_cluster" {
  name     = local.management_plane_name
  location = local.management_plane_region
  project  = local.management_plane_name
}

data "google_client_config" "default" {
  provider = google
}

data "google_container_cluster" "cp_cluster" {
  name     = local.control_plane_name
  location = local.control_plane_region
  project  = local.control_plane_name
}

data "google_secret_manager_secret_version_access" "kafka_cluster_config" {
  for_each = local.google_secret_manager_control_plane_kafka_cluster_secrets
  project  = local.control_plane_name
  secret   = each.value
}

data "aws_nat_gateways" "ngws_east" {
  provider = aws.cn-us-east
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_nat_gateway" "core_network_nat_east" {
  provider = aws.cn-us-east
  for_each = { for id in data.aws_nat_gateways.ngws_east.ids : id => id }
  id       = each.key
}

data "aws_nat_gateways" "ngws_eu" {
  provider = aws.cn-eu-west
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_nat_gateway" "core_network_nat_eu" {
  provider = aws.cn-eu-west
  for_each = { for id in data.aws_nat_gateways.ngws_eu.ids : id => id }
  id       = each.key
}

data "aws_subnets" "node" {
  filter {
    name   = format("tag:%s", var.eks_node_tag.tagKey)
    values = var.eks_node_tag.tagValues
  }
}

data "aws_subnet" "this" {
  for_each = toset(data.aws_subnets.node.ids)
  id       = each.value
}

data "gitlab_group_variable" "sentinelone_site_tokens" {
  group = "futurama"
  key   = "SENTINELONE_SITE_TOKENS"
}