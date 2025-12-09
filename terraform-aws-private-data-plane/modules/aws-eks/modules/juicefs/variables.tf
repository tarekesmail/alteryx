variable "common_tags" {
  default = {}
  type    = map(string)
}

variable "juicefs_s3_arn" {
  type = string
}

variable "eks_managed_node_groups" {}

variable "cluster_iam_role_name" {}

variable "cluster_name" {}

variable "resource_name" {
  type        = string
  description = "Unique TF workspaceid aac-<id>"
  default     = ""
}