locals {
  platform_json_content = jsonencode({
    "dataPlane" : {
      "cloud" : "${var.TARGET_CLOUD}"
      "id" : "${var.SEGMENTID}"
      "workSpaceId" : "${var.tfworkspace}"
      "clusterName" : "${var.cluster_name}"
      "clusterCAName" : "${var.resource_name}-eks-cluster-ca"
      "cluster_endpoint" : "${var.cluster_endpoint}"
      "mode" : "non-ha"
    }
    "cloud" : "${var.TARGET_CLOUD}"
    "datadog_hostname" : "${var.name}-${var.resource_name}"
    "datadog_api_key" : "${var.DATADOG_API_KEY}"
    "teleport_config" : base64encode(local.teleport_config)
    "teleport_token" : local.teleport_token_name
    "domain_name" : "${var.control_plane_domain}"
    "image_name" : data.aws_ami.selected_teleport_ami.name
  })
}
