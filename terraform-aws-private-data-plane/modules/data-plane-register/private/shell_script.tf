resource "shell_script" "teleport_finalizer_cleanup" {
  lifecycle_commands {
    create = file("${path.module}/scripts/create-teleport-cleanup.sh")
    read   = file("${path.module}/scripts/read-teleport-cleanup.sh")
    update = file("${path.module}/scripts/update-teleport-cleanup.sh")
    delete = file("${path.module}/scripts/delete-teleport-cleanup.sh")
  }

  environment = {
    CONTROL_PLANE_NAME   = var.control_plane_name
    CONTROL_PLANE_REGION = var.control_plane_region
    PDP_NAME             = var.pdp_eks_name
  }

  sensitive_environment = {
    GOOGLE_CREDENTIALS = var.GOOGLE_CREDENTIALS
  }

  working_directory = "${path.module}/scripts"
}