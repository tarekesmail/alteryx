output "AWS_ACCOUNT_ID" {
  description = "ID of the created account"
  value       = module.dp_account.id
}

output "AWS_ACCOUNT_NAME" {
  description = "Name of the created account"
  value       = local.account_name
}

# [cnotarianni] TODO: value should be an output from the dp-account module... curently we store a var in a local just to output it
output "AWS_ACCOUNT_REGION" {
  description = "Region of the created account"
  value       = local.account_region
}

output "AWS_FUTURAMA_STRUCTURE" {
  description = "Environment type lowers vs uppers"
  value       = local.structure
}

output "account_prefix" {
  description = "AWS account name prefix"
  value       = local.account_prefix
}