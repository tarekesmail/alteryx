
variable "create" {
  description = "Determines whether to run EKS module"
  type        = bool
  default     = true
}

variable "PRIVATE_EKS_API_ACCESS" {
  type = bool
}

variable "common_tags" {
  default = {}
  type    = map(string)
}

variable "vpc_name" {
  type    = string
  default = ""
}

variable "region" {
  type = string

}

variable "enable_juicefs" {
  description = "This value is set from the root module depending on the applications enabled"
  type        = bool
  default     = false
}

variable "account_id" {
  type = string

}
variable "vpc_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "color" {
  type = string

}

variable "memorydb_security_group_id" {
  description = "The ID of the MemoryDB security group"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "eks_control_subnet_tags" {
  type    = list(string)
  default = []
}

variable "eks_node_subnet_tags" {
  type    = list(string)
  default = []
}

variable "eks_config" {
  type = any
  default = {
    cluster_endpoint_public_access_cidrs = []
    cluster_addons = {
      coredns = {
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
      }
      kube-proxy = {
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
      }
      vpc-cni = {
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
      }
    }
  }
}

variable "eks_managed_node_group_defaults" {
  type = any
  default = {
    create_launch_template = false # must be set to use default eks template
    launch_template_name   = ""    # must be set to use default eks template , so it needs to be empty string
    ami_type               = "AL2_x86_64"
    disk_size              = 100
    capacity_type          = "ON_DEMAND"
    taints                 = []
  }

}

variable "eks_managed_node_groups" {
  type = any
  default = {

    default = {
      # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/compute_resources.md#eks-managed-node-groups
      # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.30.1/submodules/eks-managed-node-group?tab=inputs
      name                   = "default"
      create_launch_template = false # must be set to use default eks template
      launch_template_name   = ""    # must be set to use default eks template , so it needs to be empty string
      ami_type               = "AL2_x86_64"
      labels = {
        "type" = "default"
      }
      instance_types = ["t3a.xlarge"]
      disk_size      = 20 #default 20
      desired_size   = 1
      max_size       = 20
      min_size       = 1
      capacity_type  = "ON_DEMAND"
      taints         = []
    }
  }
}

variable "region_instance_map" {
  description = "Region specific instance types for node groups"
  type        = map(any)
}

variable "juicefs_s3_arn" {
  type = string
}

variable "eks_aws_auth_users" {
  type        = list(string)
  description = "List of user arns to add to the aws-auth configmap"
  default     = []
}

variable "eks_aws_auth_roles" {
  type        = list(string)
  description = "List of roles arns to add to the aws-auth configmap"
  default     = []
}

variable "eks_control_tag" {
  type = object({
    tagKey    = optional(string, "Name")
    tagValues = optional(list(string), [])
  })
  default = {
    tagKey    = "AACSubnet"
    tagValues = ["eks_control"]
  }
}


variable "starayx_allow_sg" {
  type = string
}

variable "teleport_allow_sg" {
  type = string
}

variable "is_lowers" {
  type = bool
}

variable "node_subnet_ids" {
  type = list(string)
}

variable "node_subnet" {
  type = map(any)
}

variable "enable_memorydb" {
  type    = bool
  default = false
}

variable "resource_name" {
  type        = string
  description = "Unique TF workspaceid aac-<id>"
  default     = ""
}
