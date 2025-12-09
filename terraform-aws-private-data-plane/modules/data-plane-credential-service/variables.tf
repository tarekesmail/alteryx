variable "eks_oidc_provider_url" {
  type        = string
  description = "AWS EKS OIDC provider url"
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "AWS EKS OIDC provider arn"
}

variable "tags" {
  type    = any
  default = {}
}

variable "resource_name" {
  type = string
}

variable "cms_key_arn" {
  type = string
}

variable "secrets" {
  type    = any
  default = {}
}
variable "region" {
  type        = string
  description = "aws pdp account region"
}

variable "control_plane" {
  type = string
}

variable "is_pdp" {
  description = "Flag to know that dp module ran"
  type        = bool
}

variable "pingone_environment_id" {
  type = string
}
