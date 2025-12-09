#################################################################
#################################################################
###### ANY CHANGES TO THESE VARIABLES REQUIRE AN UPDATE TO ######
######     https://alteryx.atlassian.net/l/cp/ycoue1qd     ######
#################################################################
#################################################################

variable "TARGET_CLOUD" {
  type = string
}

variable "FUTURAMA_STRUCTURE" {
  type = string
}

# injected from CI/CD var
variable "SECRETS" {
  description = "secrets injected into module as terraform.tfvars created from CI/CD var"
  type        = string
  default     = ""
}


variable "CONTROL_PLANE_NAME" {
  type = string
}

variable "CONTROL_PLANE_REGION" {
  type = string
}

variable "CONTROL_PLANE_DOMAIN" {
  type = string
}

variable "AWS_DATAPLANE_REGION" {
  type = string
}

variable "AWS_DATAPLANE_ID" {
  type = string
}

variable "AWS_DATAPLANE_VPC_ID" {
  type    = string
  default = ""
}

variable "TF_CLOUD_WORKSPACE" {
  type    = string
  default = ""
}

variable "eks_config" {
  type    = any
  default = null
}

variable "MANAGEMENT_PLANE_NAME" {
  type = string
}

variable "MANAGEMENT_PLANE_REGION" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "AWS_DATAPLANE_EMR_SERVERLESS_TRUSTED_AWS_ACCOUNT_IDS" {
  type    = list(string)
  default = []
}

variable "SEGMENTID" {
  type = string
}

variable "ENABLE_EMR_SERVERLESS" {
  description = "ENABLE_EMR_SERVERLESS tfcloud terraform.tfvars"
  type        = bool
  default     = false
}

variable "ENABLE_DC" {
  description = "enables Designer cloud resources whern set to true"
  type        = bool
  default     = false
}

variable "ENABLE_AML" {
  description = "enables AML resources when set to true"
  type        = bool
  default     = false
}

variable "ENABLE_AUTO_INSIGHTS" {
  description = "enables Auto Insights resources when set to true"
  type        = bool
  default     = false
}

variable "ENABLE_APPBUILDER" {
  description = "enables AppBuilder resources when set to true"
  type        = bool
  default     = false
}

variable "ENABLE_DCM_SERVICE" {
  description = "enable / disable DCM service"
  type        = bool
  default     = false
}

variable "ENABLE_CLOUD_EXECUTION" {
  description = "enables compatibility-mode module whern set to true"
  type        = bool
  default     = false
}

variable "CLOUD_EXECUTION_ENGINE_VERSION" {
  description = "CEFD engine version"
  type        = string
  default     = "2023.2"
}


variable "CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS" {
  description = "core-shared-services account user creds to allow sharing ami with pdh"
  type = object({
    AWS_ACCESS_KEY_ID     = string
    AWS_SECRET_ACCESS_KEY = string
  })
  default = null
}

variable "CLOUD_EXECUTION_AMI_OVERRIDE" {
  description = "An optional override value supplied by the IDPS for testing CEfD images in lowers"
  type        = string
  default     = ""
}

variable "CLOUD_EXECUTION_VERSIONS" {
  description = "The selected AMI version for different cloud platforms."
  type        = string
  default     = "{\"AWS\": \"latest\",\"AZURE\": \"latest\",\"GCP\": \"latest\"}"

  validation {
    condition = alltrue([
      for k, v in jsondecode(var.CLOUD_EXECUTION_VERSIONS) : v == "latest" || can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", v))
    ])
    error_message = "Invalid value for CLOUD_EXECUTION_VERSIONS. Each platform version must be a valid semantic version or 'latest'."
  }
}

variable "CLOUD_EXECUTION_AUTOSCALING_VERSIONS" {
  description = "The selected Lambda version for different cloud platforms."
  type        = string
  default     = "{\"AWS\": \"1.0.5\",\"AZURE\": \"1.0.5\",\"GCP\": \"1.0.5\"}"

  validation {
    condition = alltrue([
      for k, v in jsondecode(var.CLOUD_EXECUTION_AUTOSCALING_VERSIONS) : v == "1.0.5" || can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)$", v))
    ])
    error_message = "Invalid value for CLOUD_EXECUTION_AUTOSCALING_VERSIONS. Each platform version must follow the X.Y.Z format with numbers only or be '1.0.5'."
  }
}

locals {
  CLOUD_EXECUTION_VERSION = coalesce(var.CLOUD_EXECUTION_AMI_OVERRIDE, jsondecode(var.CLOUD_EXECUTION_VERSIONS)[var.TARGET_CLOUD], "latest")

  BPM_AMI_VERSION = coalesce(jsondecode(var.BPM_AMI_VERSIONS)[var.TARGET_CLOUD], "latest")
}

variable "CLOUD_EXECUTION_AWS_AUTOSCALING" {
  type = object({
    instance_type    = optional(string, "m5a.4xlarge")
    desired_capacity = optional(number, 2)
    max_size         = optional(number, 2)
    min_size         = optional(number, 1)
  })
  default = {}
}

variable "STARAYX_AWS_AMI_CURRENT_VERSION" {
  type    = string
  default = "latest"
}

variable "STARAYX_AWS_AUTOSCALING" {
  type = object({
    desired_capacity = optional(number, 1)
    max_size         = optional(number, 1)
    min_size         = optional(number, 1)
    instance_types   = optional(list(string), ["t3a.medium", "t3.medium", "t4g.medium"])
  })
  default = {}
}

variable "PINGONE_WORKER_APPLICATION_REGION" {
  type      = string
  sensitive = true
  validation {
    condition     = contains(["NorthAmerica"], var.PINGONE_WORKER_APPLICATION_REGION)
    error_message = <<EOT
region is required. allowed values: NorthAmerica"
EOT
  }
}

variable "PINGONE_WORKER_APPLICATION_ENVIRONMENTID" {
  type      = string
  sensitive = true
}

variable "PINGONE_WORKER_APPLICATION_CLIENTID" {
  type      = string
  sensitive = true
}

variable "PINGONE_WORKER_APPLICATION_CLIENTSECRET" {
  type      = string
  sensitive = true
}

variable "region_instance_map" {
  description = "Region specific instance types for various node groups"
  type        = map(any)
  default = {
    "us-east-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"],
      photon          = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "us-east-2" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"]
      photon          = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "us-west-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"],
      photon          = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "us-west-2" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"]
      photon          = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "ap-east-1" = {
      common          = ["m5.2xlarge", "m5d.2xlarge", "m6i.2xlarge"],
      common-job      = ["m6i.4xlarge", "m5.4xlarge"],
      photon          = ["r6i.2xlarge", "m6i.4xlarge"],
      automl          = ["m6i.4xlarge"],
      convert         = ["r6i.2xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "ap-northeast-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"],
      photon          = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "ap-northeast-2" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6i.4xlarge", "m5.4xlarge"],
      photon          = ["r6i.2xlarge", "m6i.4xlarge"],
      automl          = ["m6i.4xlarge", "m5a.4xlarge"],
      convert         = ["r6i.2xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "ap-south-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"]
      photon          = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "ap-southeast-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"],
      photon          = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "ap-southeast-2" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"],
      photon          = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "r5a.4xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "ca-central-1" = {
      common          = ["t3a.xlarge", "t3.xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"],
      photon          = ["r6i.2xlarge", "r5a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6i.4xlarge", "m5a.4xlarge"],
      convert         = ["r6i.2xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "eu-central-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"]
      photon          = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "eu-north-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6i.4xlarge", "m5.4xlarge"],
      photon          = ["r6i.2xlarge", "m6i.4xlarge"],
      automl          = ["m6i.4xlarge"],
      convert         = ["r6i.2xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "eu-west-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"]
      photon          = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "eu-west-2" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"],
      photon          = ["r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "eu-west-3" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6i.4xlarge", "m5.4xlarge"],
      photon          = ["r6i.2xlarge", "r5a.4xlarge", "m5a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6i.4xlarge", "m5a.4xlarge"],
      convert         = ["r6i.2xlarge", "r5a.4xlarge", "m5a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "r5a.4xlarge", "m5a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "r5a.4xlarge", "m5a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c5.2xlarge"]
    },
    "me-south-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6i.4xlarge", "m5.4xlarge"],
      photon          = ["r6i.2xlarge", "m6i.4xlarge"],
      automl          = ["m6i.4xlarge"],
      convert         = ["r6i.2xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    },
    "sa-east-1" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"],
      photon          = ["r6i.2xlarge", "m6a.4xlarge", "r5a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6i.2xlarge", "m6a.4xlarge", "r5a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6i.2xlarge", "m6a.4xlarge", "r5a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6i.2xlarge", "m6a.4xlarge", "r5a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    }
    "default" = {
      common          = ["t3a.2xlarge", "t3.2xlarge"],
      common-job      = ["m6a.4xlarge", "m6i.4xlarge", "m5.4xlarge", "m5a.4xlarge"]
      photon          = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      automl          = ["m6a.4xlarge", "m6i.4xlarge"],
      convert         = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      data-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      file-system     = ["r6a.2xlarge", "r6i.2xlarge", "m6a.4xlarge", "m6i.4xlarge"],
      bullmq-standard = ["c6a.2xlarge", "c5.2xlarge"]
    }
  }
}

variable "CORE_NETWORK_CREDENTIALS" {
  description = "core-networking account user creds to allow nat ip's on egress"
  type = map(object({
    AWS_ACCESS_KEY_ID     = string
    AWS_SECRET_ACCESS_KEY = string
  }))
  default = null
}

# TODO: remove
variable "KUBERNETES_VERSIONS" {
  description = "k8s master and node ami versions"
  type        = string
  default     = "{\"k8sVersion\": \"1.27\",\"eksNodeAmi\": \"\",\"azureOverride\": \"\",\"awsOverride\": \"\",\"gcpOverride\": \"\"}"
}

variable "AWS_KEY_ARN" {
  type    = string
  default = ""
}

variable "DEPLOY_PLATFORM" {
  type    = string
  default = "tfcloud"
}

variable "GCP_CSS_SECRET_KEY" {
  type        = string
  description = "Base64 encoded GCP service account secret key for auth via WI."
  sensitive   = true
}

variable "CLOUD_EXECUTION_MAX_SCALING" {
  type        = number
  default     = 2
  description = "Maximum number of cefd instances to scale to, number of partitions on kafka topic"
}

variable "DATAPLANE_TYPE" {
  type    = string
  default = "private"
}

variable "futurama_private_gitlab_token" {
  description = "gitlab token"
}

variable "gitlab_global_project" {
  description = "gitlab globals project id"
  default     = "15357"
}
variable "ENABLE_BRIDGE_PROXY_MANAGER" {
  type    = bool
  default = false
}

variable "BPM_AMI_VERSIONS" {
  description = "The selected AMI versions for BPM in different cloud platforms."
  type        = string
  default     = "{\"AWS\": \"latest\",\"AZURE\": \"latest\",\"GCP\": \"latest\"}"

  validation {
    condition = alltrue([
      for k, v in jsondecode(var.BPM_AMI_VERSIONS) :
      v == "latest" || can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", v))
    ])
    error_message = "Invalid value for BPM_AMI_VERSIONS. Each platform version must be a valid semantic version or 'latest'."
  }
}

variable "BPM_AWS_AUTOSCALING" {
  type = object({
    desired_capacity = optional(number, 1)
    max_size         = optional(number, 1)
    min_size         = optional(number, 1)
    instance_types   = optional(list(string), ["t3a.2xlarge"])
  })
  default = {}
}
variable "COREDNS_AWS_AMI_CURRENT_VERSION" {
  type    = string
  default = "latest"
}
variable "COREDNS_AWS_AUTOSCALING" {
  type = object({
    desired_capacity = optional(number, 1)
    max_size         = optional(number, 1)
    min_size         = optional(number, 1)
    instance_types   = optional(list(string), ["t3a.2xlarge"])
  })
  default = {}
}

variable "eks_node_tag" {
  type = object({
    tagKey    = optional(string, "Name")
    tagValues = optional(list(string), [])
  })
  default = {
    tagKey    = "AACSubnet"
    tagValues = ["eks_node"]
  }
}
variable "TELEPORT_AWS_AMI_CURRENT_VERSION" {
  type    = string
  default = "latest"
}

variable "TELEPORT_AWS_AUTOSCALING" {
  type = object({
    max_size       = optional(number, 1)
    min_size       = optional(number, 1)
    instance_types = optional(list(string), [])
  })
  default = {}
}

variable "ENABLE_PRIVATE_K8S_API_ACCESS" {
  description = "value to enable private api access"
  type        = bool
  default     = false
}

variable "ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER" {
  type    = bool
  default = false
}

variable "LICENSE_TIER" {
  description = "License tier for CEfD shared data plane. One of basic, professional, enterprise if cefdshared data plane. Can be empty otherwise."
  type        = string
  default     = ""
}

variable "kafka_tf_secret_list" {
  type        = list(string)
  description = "List of GSM secret names containing Kafka SA config to fetch"
  # hard-coding list for now, would like to pass this in from tfvars later
  default = [
    "kafka-bpm-sdp-sa-id",
    "kafka-bpm-sdp-sa-name",
    "kafka-tf-bpm-sdp-api-key-id",
    "kafka-tf-bpm-sdp-api-key-secret",
    "kafka-tf-bpm-sdp-sr-key-id",
    "kafka-tf-bpm-sdp-sr-key-secret",
  ]
}