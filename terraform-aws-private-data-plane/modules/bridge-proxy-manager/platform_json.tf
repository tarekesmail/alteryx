locals {
  platform_json_content = jsonencode({
    "dataPlane" : {
      "cloud" : "${var.TARGET_CLOUD}"
      "id" : "${var.SEGMENTID}"
      "dataplaneID" : "${var.tfworkspace}"
      "controlPlane" : "${var.control_plane_name}"
      "resourcePrefix" : "${var.resource_name}"
      "staticIp" : "${var.core_dns_static_ip}"
      "vpcresolverIp" : "${local.vpc_resolver_ip}"
    }
    "cloud" : "${var.TARGET_CLOUD}"
    "domain_prefix" : "${var.domain_prefix}"
    "datadog_hostname" : "${var.name}-${var.resource_name}"
    "datadog_api_key" : "${var.DATADOG_API_KEY}"
    "teleport_config" : base64encode(local.teleport_config)
    "teleport_token" : local.teleport_token_name
    "domain_name" : "${var.control_plane_domain}"
    "image_name" : data.aws_ami.selected_bridgeproxy-manager_ami.name
    "sentinelone_site_token" : "${var.sentinelone_site_token}"
  })
}
