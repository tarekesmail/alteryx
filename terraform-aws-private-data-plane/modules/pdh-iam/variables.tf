variable "aac_sa_name" {
  type    = string
  default = "aac_automation_sa"
}

variable "enabled_policies" {
  type        = list(string)
  description = "IAM policies to be enabled for data plane features"
  default     = ["base", "designer-cloud", "machine-learning", "cloud-execution", "cloud-execution-customization"]

  validation {
    condition = alltrue([
      for p in var.enabled_policies :
      contains([
        "base",
        "designer-cloud",
        "machine-learning",
        "cloud-execution",
        "cloud-execution-customization"
      ], p)
    ])
    error_message = "Enabled policies must contain valid iam policies as named in the modules/pdh-iam/policies folder"
  }
}

variable "prefix" {
  type        = string
  description = "Prefix for data plane account name (e.g. cefdsdp, ddp)"
  default     = "ddp"
}

variable "create_bridge_private_link_role" {
  type        = bool
  description = "Whether to create the Bridge Private Link IAM role and policy"
  default     = true
}