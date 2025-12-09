resource "gitlab_repository_file" "globals_data_plane" {
  project        = var.gitlab_global_project #data.gitlab_project.project.id
  file_path      = "private_data_planes/${local.resource_name}.yaml"
  branch         = "main"
  content        = base64encode(local.data_plane_globals)
  commit_message = "add/update data plne globals"
  // file will be overwritten if it already exists and added to state
  overwrite_on_create = true
}

locals {
  data_plane_globals = <<EOT
---
ingress-nginx:
  controller:
    service:
      loadBalancerSourceRanges: ${jsonencode(data.aws_vpc.selected.cidr_block_associations[*].cidr_block)}
EOT
}