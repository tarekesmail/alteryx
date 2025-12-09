variable "FUTURAMA_STRUCTURE" {
  type = string
}

variable "resource_name" {
  type = string
}


variable "memorydb_type" {
  type = string
}

variable "memorydb_replica_per_shard" {
  type = string
}

variable "secrets" {
  type    = any
  default = {}
}

variable "data_plane_vpc_id" {
  type        = string
  description = "AWS data plane vpc id"
}

variable "region" {
  type        = string
  description = "aws account region"
}

variable "tags" {
  type    = any
  default = {}
}
