# [cnotarianni] TODO: these should be created in the eks_blue module and then the ID can be referenced as an output for proper dependency graphing
# not quite sure how this hasn't caused issues yet

resource "aws_security_group" "allow_starayx_to_eks" {
  count       = local.k8s_option_enabled ? 1 : 0
  name        = "allow_starayx_to_eks"
  description = "SG to be placed on StarAYX VM which is referenced by EKS SG Rules to allow for HTTPS traffic"
  vpc_id      = local.data_plane_vpc_id
}

resource "aws_security_group" "teleport_agent" {
  count       = local.any_option_enabled ? 1 : 0
  name        = "teleport_agent"
  description = "Allow TLS inbound traffic to EKS Cluster"
  vpc_id      = local.data_plane_vpc_id
}
