output "AWS_DATAPLANE_ID" {
  description = "The account ID"
  value       = local.account_id
}

output "AWS_DATAPLANE_REGION" {
  description = "The account region"
  value       = local.account_region
}

output "AWS_DATAPLANE_VPC_ID" {
  description = "The VPC ID from the pdh_networking module"
  value       = module.pdh_networking.aws_vpc_id
}

output "DP_EGRESS_IPS" {
  description = "The egress ip's from pdh_networking module"
  value       = module.pdh_networking.nat_ips
}

output "AWS_ACCESS_KEY_ID" {
  description = "The access key ID for IAM user"
  value       = aws_iam_access_key.aac_automation_sa_user_key.id
}

output "AWS_SECRET_ACCESS_KEY" {
  description = "The secret access key for IAM user"
  value       = aws_iam_access_key.aac_automation_sa_user_key.secret
  sensitive   = true
}

output "ENV_VARS" {
  description = "The environment variables containing AWS keys"
  value = {
    AWS_ACCESS_KEY_ID     = aws_iam_access_key.aac_automation_sa_user_key.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.aac_automation_sa_user_key.secret
  }
  sensitive = true
}