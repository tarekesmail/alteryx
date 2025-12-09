output "emrServerless" {
  description = "EMR Serverless: Automation of control plane configuration for Private data plane"
  value       = local.EMR_OUTPUT_RESULT
}

output "kubernetesConnectionInfo" {
  description = "Kubernetes connection information for the EKS cluster"
  value       = try(jsonencode(local.EKS_CONNECTION.kubernetesConnectionInfo), jsonencode({}))
  sensitive   = true
}

output "envelopeEncryption" {
  description = "Envelope encryption configuration for the EKS cluster"
  value       = try(jsonencode(local.EKS_CONNECTION.envelopeEncryption), jsonencode({}))
  sensitive   = true
}

locals {
  EMR_OUTPUT_RESULT = var.ENABLE_EMR_SERVERLESS ? jsonencode(merge({
    "aws.emrServerless.privateDataPlane.enabled" = var.ENABLE_EMR_SERVERLESS
    }, {
    for k, v in one(module.emr).EMR_SERVERLESS : k => v
    # TODO: create this output using a for loop so we aren't hard coding map keys
    # "aws.emrServerless.resourceBucket"          = one(module.emr).EMR_SERVERLESS["aws.emrServerless.resourceBucket"]
    # "aws.emrServerless.config.subnetIds"        = one(module.emr).EMR_SERVERLESS["aws.emrServerless.config.subnetIds"]
    # "aws.emrServerless.config.securityGroupIds" = one(module.emr).EMR_SERVERLESS["aws.emrServerless.config.securityGroupIds"]
    # "aws.emrServerless.region"                  = one(module.emr).EMR_SERVERLESS["aws.emrServerless.region"]
    # "aws.emrServerless.jobRuntimeRoleArn"       = one(module.emr).EMR_SERVERLESS["aws.emrServerless.jobRuntimeRoleArn"]
    }
  )) : jsonencode({ "aws.emrServerless.privateDataPlane.enabled" = var.ENABLE_EMR_SERVERLESS })

  STARAYX_DEPLOYED               = local.k8s_option_enabled ? jsonencode(tomap({ "deployed" = true })) : jsonencode(tomap({ "deployed" = false }))
  CREDENTIAL_MGMT_INFRA_DEPLOYED = (local.k8s_option_enabled) && var.AWS_KEY_ARN != "" && local.struct[local.structure].enable_credential_service_infra ? jsonencode(tomap({ "deployed" = true })) : jsonencode(tomap({ "deployed" = false }))
}

output "cloudExecutionForDesktop" {
  description = "CEfD for kafka message"
  value = jsonencode({
    "products.cloudExecutionForDesktop.enabled" = var.ENABLE_CLOUD_EXECUTION
    "products.cloudExecutionEngineVersion"      = var.ENABLE_CLOUD_EXECUTION ? var.CLOUD_EXECUTION_ENGINE_VERSION : "NOT AVAILABLE"
  })
}

output "emr_serverless_resourceBucket" {
  description = "EMR Serverless: Automation of control plane configuration for Private data plane"
  value       = try(one(module.emr).serverless.resourceBucket, "NOT_AVAILABLE")
}

output "emr_serverless_subnetIds" {
  description = "EMR Serverless: Automation of control plane configuration for Private data plane"
  value       = jsonencode(try(one(module.emr).serverless.subnetIds, []))
}

output "emr_serverless_securityGroups" {
  description = "EMR Serverless: Automation of control plane configuration for Private data plane"
  value       = jsonencode(try(one(module.emr).serverless.securityGroups, []))
}

output "emr_serverless_region" {
  description = "EMR Serverless: Automation of control plane configuration for Private data plane"
  value       = try(one(module.emr).serverless.region, "NOT_AVAILABLE")
}

output "emr_serverless_jobRuntimeRoleArn" {
  description = "EMR Serverless: Automation of control plane configuration for Private data plane"
  value       = try(one(module.emr).serverless.jobRuntimeRoleArn, "NOT_AVAILABLE")
}

output "confluentInfo" {
  description = "Confluent account resources"
  value = jsonencode({
    "confluentSaName" = length(confluent_service_account.confluent_sa) > 0 ? confluent_service_account.confluent_sa[0].display_name : "NOT_AVAILABLE",
    "confluentSaId"   = length(confluent_service_account.confluent_sa) > 0 ? confluent_service_account.confluent_sa[0].id : "NOT_AVAILABLE"
  })
}

output "starayx" {
  description = "Starayx for kafka message"
  value       = local.STARAYX_DEPLOYED
}

output "designerCloud" {
  description = "ProductMatrix designerCloud output to Tfcloud for kafka Notify message"
  value       = jsonencode(tomap({ "products.designercloud.enabled" = var.ENABLE_DC }))
}

output "automl" {
  description = "ProductMatrix automl output to Tfcloud for kafka Notify message"
  value       = jsonencode(tomap({ "products.automl.enabled" = var.ENABLE_AML }))
}

output "autoInsights" {
  description = "ProductMatrix Auto Insights output to Tfcloud for kafka Notify message"
  value       = jsonencode(tomap({ "products.autoinsights.enabled" = var.ENABLE_AUTO_INSIGHTS }))
}

output "appBuilder" {
  description = "ProductMatrix appBuilder output to Tfcloud for kafka Notify message"
  value       = jsonencode(tomap({ "products.appbuilder.enabled" = var.ENABLE_APPBUILDER }))
}

output "enablePrivateCredentialStorage" {
  description = "Infra for Credential Management Service"
  value       = local.CREDENTIAL_MGMT_INFRA_DEPLOYED
}

output "coredns_private_ip" {
  description = "The private IP assigned to the CoreDNS ENI."
  # does this work? not referencing a key for the module ex module.coredns[local.account_name]
  value = try(module.coredns.coredns_private_ip, "NOT_AVAILABLE")
}

output "enableCloudExecutionCustomization" {
  description = "Enable custom drivers for CEfD"
  value       = jsonencode(tomap({ "enabled" = var.ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER }))
}

output "license_tier" {
  description = "CEfD Shared Data Plane license tier"
  value = jsonencode(tomap({
    "licenseTier" = coalesce(var.LICENSE_TIER, "NOT_AVAILABLE")
  }))
}

output "cluster_name" {
  description = "The name of the DDP cluster"
  value       = try(module.eks_blue[0].cluster_name, null)
}