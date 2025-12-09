
variable "TF_CLOUD_WORKSPACE" {
  type = string
}

variable "CONTROL_PLANE_DOMAIN" {
  type = string
}

variable "name" {
  type    = string
  default = "compatibility-mode"
}

variable "control_plane_name" {
  type = string
}

variable "autoscaling" {
  type = object({
    desired_capacity = optional(number, 2)
    max_size         = optional(number, 2)
    min_size         = optional(number, 0)
  })
  default = {}
}

variable "vpc_tag" {
  type = object({
    key   = string
    value = string
  })
  description = "describe your variable"
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
  description = "describe your variable"
  default = {
    key   = "AACSubnet"
    value = "option"
  }
}

variable "account_name" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type    = any
  default = {}
}

variable "secrets" {
  type    = any
  default = {}
}

variable "user_data" {
  type        = string
  description = "ec2 userData : https://docs.datadoghq.com/agent/basic_agent_usage/windows/?tab=gui#configuration"
  default     = <<UDATA
<powershell>
cd C:\Software
.\install_datadog.ps1 __AYX_RESOURCE_PLACEHOLDER__
</powershell>
UDATA
}

variable "CONFLUENT_KAFKA_ENABLED" {
  type        = bool
  description = "enable sa and topic creation on confluent + secrets"
  default     = true
}

variable "CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS" {
  description = "core-shared-services account user creds to allow sharing ami with pdh"
  type = object({
    AWS_ACCESS_KEY_ID     = string
    AWS_SECRET_ACCESS_KEY = string
  })
  default = null
}

variable "CLOUD_EXECUTION_AWS_AMI_NAME_PREFIX_REGEX" {
  description = "core-shared-services pdh compatibility-mode amis to be shared"
  type        = string
  default     = "cefd-ltsc2022-v-"
}

variable "CLOUD_EXECUTION_AWS_AMI_CURRENT_VERSION" {
  description = "the selected ami version. when set to latest the ami with more recent creation date is picked up as well when a selected version is not found. Otherwise the matching version is selected."
  type        = string
  default     = "latest"
  validation {
    error_message = "Must be valid semantic version or latest."
    condition     = try(var.CLOUD_EXECUTION_AWS_AMI_CURRENT_VERSION == "latest", false) || can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", var.CLOUD_EXECUTION_AWS_AMI_CURRENT_VERSION))
  }
}

variable "SEGMENTID" {
  type = string
}

variable "DISABLE_VPC_ENDPOINTS" {
  type    = bool
  default = true
}

variable "FUTURAMA_STRUCTURE" {
  type = string
}

variable "TARGET_CLOUD" {
  type = string
}

variable "CLOUD_EXECUTION_ENGINE_VERSION" {
  type = string
}

variable "CLOUD_EXECUTION_MAX_SCALING" {
  type    = number
  default = 2
}

variable "CLOUD_EXECUTION_MIN_ASG_SIZE" {
  type    = number
  default = 1
}

variable "CLOUD_EXECUTION_AUTOSCALING_VERSIONS" {
  description = "CEFD AutoScaling version for different cloud platforms."
  type        = string
}

variable "ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER" {
  description = "Enable custom driver installation for CEFD"
  type        = bool
  default     = false
}

variable "ENABLE_COREDNS" {
  description = "Enable Core DNS"
  type        = bool
}

variable "ENABLE_DCM_SERVICE" {
  description = "Flag to enable or disable DCM service"
  type        = bool
  default     = false
}

variable "DATAPLANE_TYPE" {
  type = string
}

variable "license_tier" {
  description = "License tier for CEfD shared data plane. One of basic, professional, enterprise"
  type        = string
  default     = ""
}

variable "is_cefdshared" {
  description = "Bool indicating if the dataplane type is cefdshared"
  type        = bool
  default     = false
}

variable "worker_timeout" {
  description = "Cloud Execution worker timeout in seconds"
  type        = number
  default     = 43200
}