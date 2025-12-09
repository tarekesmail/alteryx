// creates defined acl's
resource "confluent_kafka_acl" "workspace_cloudexecution" {
  for_each = !var.CONFLUENT_KAFKA_ENABLED ? tomap({}) : tomap({

    ("${var.control_plane_name}-cloudexecution-${var.SEGMENTID}-") = {
      resource_type = "TOPIC"
      pattern_type  = "PREFIXED"
      host          = "*"
      operation     = "READ"
      permission    = "ALLOW"
    }

    "*" = {
      resource_type = "GROUP"
      pattern_type  = "PREFIXED"
      pattern_type  = "LITERAL"
      host          = "*"
      operation     = "READ"
      permission    = "ALLOW"
    }

    (nonsensitive(data.google_secret_manager_secret_version_access.kafka["kafka-topic-jobstatus-name"].secret_data)) = {
      resource_type = "TOPIC"
      pattern_type  = "LITERAL"
      host          = "*"
      operation     = "WRITE"
      permission    = "ALLOW"
    }

    (nonsensitive(data.google_secret_manager_secret_version_access.kafka["kafka-topic-renderstatus-name"].secret_data)) = {
      resource_type = "TOPIC"
      pattern_type  = "LITERAL"
      host          = "*"
      operation     = "WRITE"
      permission    = "ALLOW"
    }
  })

  kafka_cluster {
    id = one(data.confluent_kafka_cluster.control_plane_cluster).id
  }

  # https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_acl#credentials
  credentials {
    key    = data.google_secret_manager_secret_version_access.kafka["kafka-sa-api-key-id"].secret_data
    secret = data.google_secret_manager_secret_version_access.kafka["kafka-sa-api-key-secret"].secret_data
  }

  resource_name = each.key
  resource_type = each.value.resource_type
  pattern_type  = each.value.pattern_type
  principal     = try(each.value.principal, "User:${one(confluent_service_account.workspace_cloudexecution).id}")
  host          = each.value.host
  operation     = each.value.operation
  permission    = try(each.value.permission, one(data.confluent_kafka_cluster.control_plane_cluster).rest_endpoint)
  rest_endpoint = try(each.value.rest_endpoint, one(data.confluent_kafka_cluster.control_plane_cluster).rest_endpoint)
}
