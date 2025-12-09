
resource "aws_kms_key" "eks_secret" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 10
  tags                    = local.common_tags
}

module "eks" {
  #  source                                   = "terraform-aws-modules/eks/aws"
  #  version                                  = "20.23.0"
  source = "./terraform-aws-eks"

  enable_cluster_creator_admin_permissions = false

  create_cloudwatch_log_group = false

  createtime_cluster_creator_admin = true

  authentication_mode = "CONFIG_MAP"

  cluster_endpoint_private_access = lookup(var.eks_config, "cluster_endpoint_private_access", true)
  cluster_endpoint_public_access  = lookup(var.eks_config, "cluster_endpoint_public_access", (var.PRIVATE_EKS_API_ACCESS ? false : true))

  cluster_name    = var.cluster_name
  cluster_version = lookup(var.eks_config, "cluster_version", "1.22")

  create_kms_key = false

  cluster_security_group_additional_rules = { ingress_starayx = {
    "type"                       = "ingress",
    "description"                = "Allow traffic from StarAYX",
    "type"                       = "ingress",
    "from_port"                  = 443,
    "to_port"                    = 443,
    "protocol"                   = "TCP",
    "source_node_security_group" = false,
    "source_security_group_id" = var.starayx_allow_sg },
    ingress_teleport = {
      "type"                       = "ingress",
      "description"                = "Allow traffic from Teleport",
      "type"                       = "ingress",
      "from_port"                  = 443,
      "to_port"                    = 443,
      "protocol"                   = "TCP",
      "source_node_security_group" = false,
      "source_security_group_id"   = var.teleport_allow_sg
    }
  }

  vpc_id = var.vpc_id

  subnet_ids               = var.node_subnet_ids
  control_plane_subnet_ids = data.aws_subnets.control.ids

  tags = local.common_tags

  cluster_endpoint_public_access_cidrs = var.eks_config.cluster_endpoint_public_access_cidrs

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  cluster_encryption_config = {
    provider_key_arn = aws_kms_key.eks_secret.arn
    resources        = ["secrets"]
  }

  access_entries = {}


  eks_managed_node_group_defaults = merge(var.eks_managed_node_group_defaults, { subnet_ids = var.node_subnet_ids })


  eks_managed_node_groups = local.eks_managed_node_groups
}


resource "aws_eks_addon" "this" {
  for_each = var.eks_config.cluster_addons

  cluster_name = var.cluster_name
  addon_name   = try(each.value.addon_name, each.key)

  # null value for addon_version defaults to the latest compatible version
  addon_version               = lookup(each.value, "addon_version", null)
  resolve_conflicts_on_create = lookup(each.value, "resolve_conflicts_on_create", null)
  resolve_conflicts_on_update = lookup(each.value, "resolve_conflicts_on_update", null)
  service_account_role_arn    = lookup(each.value, "service_account_role_arn", null)
  preserve                    = lookup(each.value, "preserve", null)

  # configuration_values = lookup(each.value, "configuration_values", null) != null ? jsonencode(lookup(each.value, "configuration_values", {})) : null

  depends_on = [
    module.eks.eks_managed_node_groups
  ]

  tags = local.common_tags
}