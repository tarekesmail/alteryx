variable "allow_eks_traffic_sg_id" {
  type = string
}

variable "name" {
  type    = string
  default = "starayx"
}

variable "last_two_blocks_tfworkspace" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "domain_prefix" {
  type = string
}

variable "starayx_registration_endpoint" {
  type = string
}

variable "accountid" {
  type = string
}

variable "teleport_proxy_uri" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "tfworkspace" {
  type = string
}

variable "control_plane_name" {
  type = string
}

variable "control_plane_region" {
  type = string
}

variable "control_plane_domain" {
  type = string
}

variable "starayx_key_name" {
  type    = string
  default = "starayx-key"
}

variable "vpc_tag" {
  type = object({
    key   = string
    value = string
  })
  default = {
    key   = "AACResource"
    value = "aac_vpc"
  }
}

variable "subnet_tag" {
  type = object({
    key   = string
    value = string
  })
  default = {
    key   = "AACSubnet"
    value = "private"
  }
}

variable "region" {
  type = string
}

variable "tags" {
  type    = any
  default = {}
}

variable "tags_cp" {
  type    = any
  default = {}
}

variable "secrets" {
  type    = any
  default = {}
}

variable "user_data" {
  type    = string
  default = <<UDATA
UDATA
}

variable "STARAYX_AWS_AMI_SHARING_CREDS" {
  description = "core-shared-services account user creds to allow sharing ami with pdh"
  type = object({
    AWS_ACCESS_KEY_ID     = string
    AWS_SECRET_ACCESS_KEY = string
  })
  default = null
}

# ami-0d1fe01c7dae4e4c3 alteryx-wireguard-ubuntu22-0.0.8  715489977051/alteryx-wireguard-ubuntu22-0.0.8 715489977051  Private 

variable "STARAYX_AWS_AMI_NAME_PREFIX_REGEX" {
  description = "core-shared-services pdh compatibility-mode amis to be shared"
  type        = string
  default     = "starayx-v-"
}

variable "STARAYX_AWS_AMI_CURRENT_VERSION" {
  description = "the selected ami version. when set to latest the ami with more recent creation date is picked up as well when a selected version is not found. Otherwise the matching version is selected."
  type        = string
  validation {
    error_message = "Must be valid semantic version or latest."
    condition     = try(var.STARAYX_AWS_AMI_CURRENT_VERSION == "latest", false) || can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", var.STARAYX_AWS_AMI_CURRENT_VERSION))
  }
}

variable "STARAYX_AWS_AUTOSCALING" {
  type = object({
    desired_capacity = number
    max_size         = number
    min_size         = number
    instance_types   = list(string)
  })
}

variable "STARAYX_CONTROL_PLANE_IPS" {
  type = list(string)
}

variable "SEGMENTID" {
  type = string
}

variable "TARGET_CLOUD" {
  type = string
}

variable "STARAYX_PINGONE" {
  sensitive = true
  type = object({
    environment_id = string
    apiURL         = string
  })
}

variable "cluster_ca_cert" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "DATADOG_API_KEY" {
  type      = string
  sensitive = true
}

variable "memorydb_security_group_id" {
  description = "The ID of the MemoryDB security group"
  type        = string
  default     = "null"
}
variable "enable_memorydb" {
  type    = bool
  default = false
}
variable "sentinelone_site_token" {
  description = "Futurama SentinelOne site token"
  type        = string
  default     = "null"
}