
output "selected_ami" {
  description = "The selected AMI for Teleport deployment"
  value       = local.TELEPORT_SELECTED_AMI
}

output "secrets" {
  description = "Secrets module configuration for Teleport"
  value       = module.secrets
}

