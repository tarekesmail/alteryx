module "data_plane_memorydb_secrets_manager" {
  source                  = "../secrets_manager"
  secrets                 = merge(local.secrets, var.secrets)
  recovery_window_in_days = 0
  tags                    = var.tags
}
