
output "selected_ami" {
  description = "The selected AMI for Starayx deployment"
  value       = local.STARAYX_SELECTED_AMI
}

output "secrets" {
  description = "Secrets module configuration for Starayx"
  value       = module.secrets
}

