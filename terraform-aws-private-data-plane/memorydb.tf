# StarAYX uses memorydb
locals {
  enable_memorydb = local.k8s_option_enabled && local.struct[local.structure].enable_memorydb
}

module "memorydb" {
  count = local.enable_memorydb ? 1 : 0

  source                     = "./modules/data-plane-memorydb"
  FUTURAMA_STRUCTURE         = local.structure
  region                     = var.AWS_DATAPLANE_REGION
  data_plane_vpc_id          = var.AWS_DATAPLANE_VPC_ID
  memorydb_replica_per_shard = local.struct[local.structure].memorydb_replica_per_shard
  memorydb_type              = local.struct[local.structure].memorydb_type
  resource_name              = local.resource_name
  tags                       = local.common_labels
}