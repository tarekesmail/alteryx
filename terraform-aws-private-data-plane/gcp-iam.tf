locals {
  roles_pdp_gar_iam = toset([
    "roles/artifactregistry.reader",
  ])
}

resource "google_service_account" "pdp_gar_sa" {
  count        = local.k8s_option_enabled ? 1 : 0
  project      = local.control_plane_name
  account_id   = "${local.resource_name}-gar-sa"
  display_name = "gar access for pdp"
}

resource "google_service_account_key" "pdp_gar_sa_key" {
  count              = local.k8s_option_enabled ? 1 : 0
  service_account_id = google_service_account.pdp_gar_sa[count.index].name
  public_key_type    = "TYPE_X509_PEM_FILE"
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

resource "google_project_iam_member" "pdp_gar_iam" {
  for_each = local.k8s_option_enabled ? local.roles_pdp_gar_iam : toset([])
  project  = local.management_plane_name
  role     = each.key
  member   = format("serviceAccount:%s", google_service_account.pdp_gar_sa[0].email)
}