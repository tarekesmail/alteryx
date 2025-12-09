
# SA for Workspace CloudExecution
resource "confluent_service_account" "workspace_cloudexecution" {
  count        = var.CONFLUENT_KAFKA_ENABLED ? 1 : 0
  display_name = "${var.control_plane_name}-cloudexecution-${var.SEGMENTID}-sa"
  description  = "Service account to use '${var.control_plane_name}-cloudexecution-*-${var.SEGMENTID}' topics of '${var.control_plane_name}' Kafka cluster"
}

# API KEY for Workspace CloudExecution
resource "confluent_api_key" "workspace_cloudexecution" {
  count        = var.CONFLUENT_KAFKA_ENABLED ? 1 : 0
  display_name = "${var.control_plane_name}-cloudexecution-${var.SEGMENTID}-api-key"
  description  = "Kafka API Key that is owned by '${var.control_plane_name}-cloudexecution-${var.SEGMENTID}' service account"
  owner {
    id          = one(confluent_service_account.workspace_cloudexecution).id
    api_version = one(confluent_service_account.workspace_cloudexecution).api_version
    kind        = one(confluent_service_account.workspace_cloudexecution).kind
  }

  managed_resource {
    id          = one(data.confluent_kafka_cluster.control_plane_cluster).id
    api_version = one(data.confluent_kafka_cluster.control_plane_cluster).api_version
    kind        = one(data.confluent_kafka_cluster.control_plane_cluster).kind

    environment {
      id = one(data.confluent_environment.environment_name).id
    }
  }
}

