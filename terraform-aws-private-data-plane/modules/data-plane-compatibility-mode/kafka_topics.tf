
# topic(s) creation
# This creates topics with AACP Workspace ID (var.SEGMENTID)
# https://alteryx.atlassian.net/wiki/spaces/GAL/pages/2119892997/Kafka+Topics
locals {
  kafka_topics = toset(["jobqueue", "jobcancel", "renderqueue"])
}

resource "confluent_kafka_topic" "workspace_cloudexecution" {
  for_each = var.CONFLUENT_KAFKA_ENABLED ? local.kafka_topics : toset([])

  partitions_count = (each.value == "jobqueue") ? max(var.CLOUD_EXECUTION_MAX_SCALING, 2) : 6

  kafka_cluster {
    id = one(data.confluent_kafka_cluster.control_plane_cluster).id
  }
  topic_name    = "${var.control_plane_name}-cloudexecution-${var.SEGMENTID}-${each.value}"
  rest_endpoint = one(data.confluent_kafka_cluster.control_plane_cluster).rest_endpoint

  # https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_acl#credentials
  credentials {
    key    = data.google_secret_manager_secret_version_access.kafka["kafka-sa-api-key-id"].secret_data
    secret = data.google_secret_manager_secret_version_access.kafka["kafka-sa-api-key-secret"].secret_data
  }

}
