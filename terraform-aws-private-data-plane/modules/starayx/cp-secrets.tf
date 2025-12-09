module "file-secrets" {
  source             = "../gcp-secrets"
  management_project = var.control_plane_name
  management_region  = var.control_plane_region
  management_cluster = var.control_plane_name
  common_labels      = var.tags_cp

  secret_list = {
    "${var.last_two_blocks_tfworkspace}-starayx-auth-pingone-config" = {
      value = jsonencode({
        client_id     = pingone_application.starayx_auth.oidc_options[0].client_id
        client_secret = pingone_application.starayx_auth.oidc_options[0].client_secret
        scope         = var.tfworkspace
      })
      tag = "data-plane"
    }

  }
}
