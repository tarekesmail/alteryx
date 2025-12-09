variable "vpc_id" {
  type = string
}

variable "FUTURAMA_STRUCTURE" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "teleport_agent_base_ami" {
  type = string
}

variable "teleport_proxy_uri" {
  type = string
}

variable "teleport_cluster" {
  type = string
}

variable "teleport_eks_host" {
  type = string
}

variable "teleport_windows_token" {
  type = string
}

variable "teleport_min_size" {
  type = number
}

variable "account_name" {
  type = string
}

variable "region" {
  type = string
}

variable "control_plane_name" {
  type    = string
  default = ""
}

variable "resource_name" {
  type = string
}

variable "SEGMENTID" {
  type    = string
  default = ""
}

variable "TF_CLOUD_WORKSPACE" {
  type = string
}

variable "CONTROL_PLANE_DOMAIN" {
  type = string
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
#no

variable "teleport_eks_enabled" {
  type = bool
}

variable "eks_security_group_id" {
  type = string
}
