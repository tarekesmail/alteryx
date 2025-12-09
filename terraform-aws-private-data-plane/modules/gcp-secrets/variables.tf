variable "management_project" {
  type = string
}

variable "management_cluster" {
  type = string
}

variable "management_region" {
  type = string
}

variable "secret_list" {
  description = "List of secrets to push into GCP Secret Manager"
  type        = map(any)
  default = {
    placeholder_secret = {
      value = "Made The Trip",
      tag   = "ayx: test",
    },
  }
}

variable "common_labels" {
  default = {}
  type    = map(string)
}

variable "lifecycle_ignore" {
  type    = bool
  default = false
}
