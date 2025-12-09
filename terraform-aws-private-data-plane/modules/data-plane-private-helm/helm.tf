resource "helm_release" "teleport_bootstrap" {
  count            = var.eks ? 1 : 0
  name             = "teleport-bootstrap-${var.private_data_plane_name}"
  chart            = "${path.module}/mp-job-helm"
  namespace        = "pdp-registration"
  create_namespace = true

  set {
    name  = "pdpTokenName"
    value = "pdp-${var.pdp_eks_name}"
  }

  set {
    name  = "pdpName"
    value = var.private_data_plane_name
  }

  set {
    name  = "awsAccountId"
    value = var.aws_account_id
  }
  provider = helm.mp
}

resource "helm_release" "teleport_windows_bootstrap" {
  name             = "teleport-windows-bootstrap-${var.private_data_plane_name}"
  chart            = "${path.module}/cefd-job-helm"
  namespace        = "cefd-registration"
  create_namespace = true

  set {
    name  = "pdpName"
    value = var.private_data_plane_name
  }

  set_sensitive {
    name  = "teleportWindowsToken"
    value = var.teleport_windows_token
  }
  provider = helm.mp
}

resource "helm_release" "teleport_bpm_bootstrap" {
  count            = var.bpm ? 1 : 0
  name             = "teleport-bpm-bootstrap-${var.private_data_plane_name}"
  chart            = "${path.module}/bpm-job-helm"
  namespace        = "bpm-registration"
  create_namespace = true

  set {
    name  = "bpmName"
    value = var.private_data_plane_name
  }

  set {
    name  = "bpmTokenName"
    value = var.private_data_plane_name
  }
  set {
    name  = "awsAccountId"
    value = var.aws_account_id
  }
  provider = helm.mp
}

resource "helm_release" "teleport_coredns_bootstrap" {
  count            = var.coredns ? 1 : 0
  name             = "teleport-coredns-bootstrap-${var.private_data_plane_name}"
  chart            = "${path.module}/coredns-job-helm"
  namespace        = "coredns-registration"
  create_namespace = true

  set {
    name  = "corednsName"
    value = var.private_data_plane_name
  }

  set {
    name  = "corednsTokenName"
    value = var.private_data_plane_name
  }
  set {
    name  = "awsAccountId"
    value = var.aws_account_id
  }
  provider = helm.mp
}
