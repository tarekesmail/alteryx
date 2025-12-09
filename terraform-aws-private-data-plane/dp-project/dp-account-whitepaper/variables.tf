variable "PRESIDIO_AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "PRESIDIO_AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}
variable "AWS_FUTURAMA_STRUCTURE" {
  type = string
}

variable "AWS_ACCOUNT_NAME" {
  type = string
}

variable "AWS_ACCOUNT_REGION" {
  type = string
}

variable "DATAPLANE_TYPE" {
  type        = string
  description = "Data plane type. Can be 'private', 'dedicated' or 'cefdshared'"
  default     = "private"
}

variable "AWS_ACCOUNT_ID" {
  type    = string
  default = "" #remove this later
}

variable "account_prefix" {
  type        = string
  description = "AWS account name prefix (e.g. cefdsdp, ddp)"
}