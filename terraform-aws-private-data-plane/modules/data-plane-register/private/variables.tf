variable "CLUSTER_REGISTRATION" {
  description = "enforced labels / values for successful dataplane cluster registration into argocd (cp) and teleport-cluster (mp)"
  type = object({
    cloud                        = string
    clusterNetworkingToggle      = string
    controlplaneName             = string
    dataplaneID                  = string
    dataPlane                    = string
    dataplaneRegion              = string
    designerCloudToggle          = string
    domain_name                  = string
    managementplaneName          = string
    plane                        = string
    registry                     = string
    subDomainName                = string
    teleportAgentTrafficUri      = string
    aac_workspace_id             = string
    terraform_cloud_workspace_id = string
    terraform_cloud_resource_id  = string
    resourceName                 = string
    autoInsightsToggle           = string
    appBuilderToggle             = string
    resourceConductorToggle      = string
  })
}

variable "GOOGLE_CREDENTIALS" {
  type      = string
  sensitive = true
}

variable "control_plane_name" {
  type = string
}

variable "control_plane_region" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "pdp_eks_name" {
  type = string
}

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "AWS_DATAPLANE_REGION" {
  type = string
}
