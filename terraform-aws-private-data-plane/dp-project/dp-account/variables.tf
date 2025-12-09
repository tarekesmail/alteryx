variable "PRESIDIO_AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}
variable "PRESIDIO_AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "FUTURAMA_STRUCTURE" {
  type = string
}
variable "TF_CLOUD_WORKSPACE" {
  type = string
}

variable "AWS_DATAPLANE_REGION" {
  type = string
}

variable "DATAPLANE_TYPE" {
  type        = string
  description = "Data plane type. Can be 'private', 'dedicated' or 'cefdshared'"
}