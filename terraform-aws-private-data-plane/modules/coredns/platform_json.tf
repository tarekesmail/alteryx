locals {
  redis_username = var.redis_username != null ? var.redis_username : "NOT_AVAILABLE"
  redis_password = var.redis_password != null ? var.redis_password : "NOT_AVAILABLE"
  redis_address  = var.redis_endpoint != null && var.redis_port != null ? "${var.redis_endpoint}:${var.redis_port}" : "NOT_AVAILABLE"

  platform_json_content = jsonencode({
    "dataPlane" : {
      "cloud" : var.TARGET_CLOUD
      "id" : var.SEGMENTID
      "workSpaceId" : var.tfworkspace
      "staticIp" : aws_network_interface.coredns_eni.private_ip
      "resourcePrefix" : var.resource_name
      "redis_address" : local.redis_address
      "redis_user" : local.redis_username
      "redis_password" : local.redis_password
    }
    "cloud" : var.TARGET_CLOUD
    "domain_prefix" : var.domain_prefix
    "datadog_hostname" : "${var.name}-${var.resource_name}"
    "datadog_api_key" : var.DATADOG_API_KEY
    "teleport_config" : base64encode(local.teleport_config)
    "teleport_token" : local.teleport_token_name
    "domain_name" : var.control_plane_domain
    "image_name" : data.aws_ami.selected_coredns_ami.name
    "sentinelone_site_token" : var.sentinelone_site_token
  })
}