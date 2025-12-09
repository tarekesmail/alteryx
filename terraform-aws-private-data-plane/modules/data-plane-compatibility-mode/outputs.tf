

output "kafka" {
  description = "Kafka configuration from Google Secret Manager"
  value       = data.google_secret_manager_secret_version_access.kafka
  sensitive   = true
}