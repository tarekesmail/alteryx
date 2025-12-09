
variable "TF_CLOUD_WORKSPACE" {
  type = string
}

variable "CONTROL_PLANE_DOMAIN" {
  type = string
}

variable "segment_id" {
  type    = string
  default = ""
}

variable "private_data_plane_name" {
  type    = string
  default = ""
}

variable "control_plane_name" {
  type    = string
  default = ""
}

variable "pdp_eks_name" {
  type    = string
  default = ""
}

variable "pdp_eks_region" {
  type    = string
  default = ""
}

variable "aws_access_key_id" {
  type      = string
  sensitive = true
  default   = ""
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "aws_account_id" {
  type      = string
  sensitive = true
  default   = ""
}

variable "cefd" {
  type    = bool
  default = false
}

variable "argo" {
  type    = bool
  default = true
}

variable "eks" {
  type    = bool
  default = true
}

variable "bpm" {
  type    = bool
  default = false
}

variable "coredns" {
  type    = bool
  default = false
}

variable "teleport_windows_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "cloud" {
  type    = string
  default = "aws"
}

variable "argocd_bender_server" {
  type = string
}

variable "resource_name" {
  type = string
}