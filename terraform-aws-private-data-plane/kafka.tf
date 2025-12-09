data "confluent_environment" "environment_name" {
  display_name = "futurama-${var.FUTURAMA_STRUCTURE}"
}

data "confluent_kafka_cluster" "control_plane_cluster" {
  display_name = local.control_plane_name
  environment {
    id = data.confluent_environment.environment_name.id
  }
}

locals {
  create_confluent_sa = local.any_option_enabled
}

# SA for Workspace
resource "confluent_service_account" "confluent_sa" {
  count        = local.create_confluent_sa ? 1 : 0
  display_name = "${local.control_plane_name}-${var.TF_CLOUD_WORKSPACE}-sa"
  description  = "Service account name '${local.control_plane_name}-${var.TF_CLOUD_WORKSPACE}-sa'"
}

# API KEY for Workspace
resource "confluent_api_key" "confluent_api_key" {
  count        = local.create_confluent_sa ? 1 : 0
  display_name = "${local.control_plane_name}-${var.TF_CLOUD_WORKSPACE}-api-key"
  description  = "Kafka API Key that is owned by '${local.control_plane_name}-${var.TF_CLOUD_WORKSPACE}-api-key' service account"
  owner {
    id          = confluent_service_account.confluent_sa[0].id
    api_version = confluent_service_account.confluent_sa[0].api_version
    kind        = confluent_service_account.confluent_sa[0].kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.control_plane_cluster.id
    api_version = data.confluent_kafka_cluster.control_plane_cluster.api_version
    kind        = data.confluent_kafka_cluster.control_plane_cluster.kind

    environment {
      id = data.confluent_environment.environment_name.id
    }
  }
}

locals {
  create_kafka_secrets = local.any_option_enabled

  # Conditional merge for KAFKA_SECRETS
  KAFKA_SECRETS = local.create_kafka_secrets ? merge(
    # KAFKA Cluster
    local.kafka_cluster_id_secret,
    local.kafka_cluster_bootstrap_endpoint_secret,
    local.kafka_cluster_bootstrap_endpoint_scheme_secret,
    local.kafka_cluster_schema_registry_endpoint_secret,
    ## KAFKA SA
    local.kafka_sa_json_secret_secret,
    local.kafka_sa_api_key_secret_secret,
    local.kafka_sa_api_key_id_secret,
    local.kafka_sa_id_secret,
    local.kafka_sa_name_secret,
    local.kafka_cluster_rest_endpoint,
    local.kafka_secret_json_secret,
    local.bpm_kafka_secret_json_secret
  ) : {}

  #naming convention AWS secrets https://alteryx.atlassian.net/wiki/spaces/DAT/pages/1855193832/Infrastructure+requirements+-+AiDIN+split+plane#SDP%3A
  # why do this if only used once?
  kafka_secret_json_secret_key                   = "${local.resource_name}-kafka-secret-json"
  kafka_cluster_id_sm_key                        = "${local.resource_name}-kafka-cluster-id"
  kafka_cluster_bootstrap_endpoint_sm_key        = "${local.resource_name}-kafka-cluster-bootstrap-endpoint"
  kafka_cluster_bootstrap_endpoint_scheme_sm_key = "${local.resource_name}-kafka-cluster-bootstrap-scheme"
  kafka_cluster_schema_registry_endpoint_sm_key  = "${local.resource_name}-kafka-cluster-schema-registry-endpoint"
  kafka_cluster_rest_endpoint_sm_key             = "${local.resource_name}-kafka-cluster-rest-endpoint"

  google_secret_manager_control_plane_kafka_cluster_secrets = toset([
    "kafka-cluster-id",
    "kafka-cluster-bootstrap-endpoint",
    "kafka-cluster-bootstrap-scheme",
    "kafka-cluster-schema-registry-endpoint",
    "kafka-cluster-rest-endpoint",
    "kafka-schema-registry-sa-api-key-id",
    "kafka-schema-registry-sa-api-key-secret"
  ])

  kafka_cluster_id_secret = {
    "${local.kafka_cluster_id_sm_key}" = {
      description      = "data-plane kafka cluster Id"
      secret_key_value = data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-id"].secret_data
    }
  }

  kafka_cluster_bootstrap_endpoint_secret = {
    "${local.kafka_cluster_bootstrap_endpoint_sm_key}" = {
      description      = "data-plane kafka cluster endpoint"
      secret_key_value = data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-bootstrap-endpoint"].secret_data
    }
  }
  kafka_cluster_bootstrap_endpoint_scheme_secret = {
    "${local.kafka_cluster_bootstrap_endpoint_scheme_sm_key}" = {
      description      = "data-plane kafka cluster endpoint scheme"
      secret_key_value = data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-bootstrap-scheme"].secret_data
    }
  }
  kafka_cluster_schema_registry_endpoint_secret = {
    "${local.kafka_cluster_schema_registry_endpoint_sm_key}" = {
      description      = "data-plane kafka cluster schema registry endpoint"
      secret_key_value = data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-schema-registry-endpoint"].secret_data
    }
  }
  kafka_cluster_rest_endpoint = {
    "${local.kafka_cluster_rest_endpoint_sm_key}" = {
      description      = "data-plane kafka cluster rest endpoint"
      secret_key_value = data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-rest-endpoint"].secret_data
    }
  }

  kafka_sa_secret_json = <<JSON
  {
    "serviceId": "${local.create_confluent_sa ? confluent_service_account.confluent_sa[0].id : ""}",
    "apiKeyId": "${local.create_confluent_sa ? confluent_api_key.confluent_api_key[0].id : ""}",
    "apiKeySecret": "${local.create_confluent_sa ? confluent_api_key.confluent_api_key[0].secret : ""}"
  }
  JSON 

  kafka_sa_name_sm_key           = "${local.resource_name}-kafka-sa-name"
  kafka_sa_id_sm_key             = "${local.resource_name}-kafka-sa-id"
  kafka_sa_api_key_id_sm_key     = "${local.resource_name}-kafka-sa-api-key-id"
  kafka_sa_api_key_secret_sm_key = "${local.resource_name}-kafka-sa-api-key-secret"
  kafka_sa_secret_json_sm_key    = "${local.resource_name}-kafka-sa-secret-json"

  kafka_sa_name_secret = {
    "${local.kafka_sa_name_sm_key}" = {
      description      = "data-plane kafka service account name"
      secret_key_value = local.create_confluent_sa ? confluent_service_account.confluent_sa[0].display_name : ""
    }
  }

  kafka_sa_id_secret = {
    "${local.kafka_sa_id_sm_key}" = {
      description      = "data-plane kafka service account Id"
      secret_key_value = local.create_confluent_sa ? confluent_service_account.confluent_sa[0].id : ""
    }
  }
  kafka_sa_api_key_id_secret = {
    "${local.kafka_sa_api_key_id_sm_key}" = {
      description      = "data-plane kafka service account api key id"
      secret_key_value = local.create_confluent_sa ? confluent_api_key.confluent_api_key[0].id : ""
    }
  }

  kafka_sa_api_key_secret_secret = {
    "${local.kafka_sa_api_key_secret_sm_key}" = {
      description      = "data-plane kafka service account api key secret"
      secret_key_value = local.create_confluent_sa ? confluent_api_key.confluent_api_key[0].secret : ""
    }
  }
  kafka_sa_json_secret_secret = {
    "${local.kafka_sa_secret_json_sm_key}" = {
      description      = "data-plane kafka service account json secret"
      secret_key_value = local.kafka_sa_secret_json
    }
  }

  # update with bpm-sdp creds
  kafka_secret_json_secret = {
    "${local.kafka_secret_json_secret_key}" = {
      description      = "Detailed info about Kafka connections and schema for ${local.resource_name}"
      secret_key_value = <<JSON
  {
          "serviceSAId": "${local.create_confluent_sa ? confluent_service_account.confluent_sa[0].id : ""}",
          "serviceSAName": "${local.create_confluent_sa ? confluent_service_account.confluent_sa[0].display_name : ""}",
          "serviceSAApiKeyId": "${local.create_confluent_sa ? confluent_api_key.confluent_api_key[0].id : ""}",
          "serviceSAApiKeySecret": "${local.create_confluent_sa ? confluent_api_key.confluent_api_key[0].secret : ""}",
          "schemaRegistryEndpoint": "${data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-schema-registry-endpoint"].secret_data}",
          "schemaApiKeyId": "${data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-schema-registry-sa-api-key-id"].secret_data}",
          "schemaApiKeySecret": "${data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-schema-registry-sa-api-key-secret"].secret_data}",
          "clusterRestEndpoint": "${data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-rest-endpoint"].secret_data}",
          "clusterId": "${jsondecode(data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-id"].secret_data).clusterId}",
          "clusterBootstrapEndpoint": "${data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-bootstrap-endpoint"].secret_data}",
          "clusterBootstrapScheme": "SASL_SSL"
  }
  JSON
    }
  }
}

data "google_secret_manager_secret_version_access" "kafka_secrets" {
  for_each = local.is_cefdshared ? toset(var.kafka_tf_secret_list) : toset([])

  project = local.control_plane_name
  secret  = each.value
}

locals {
  bpm_kafka_secret_json_secret = local.is_cefdshared ? {
    "${local.resource_name}-bpm-kafka-secret-json" = {
      description = "Detailed info about Kafka connections and schema for bpm-sdp-sa"
      secret_key_value = jsonencode({
        "serviceSAId"              = try(data.google_secret_manager_secret_version_access.kafka_secrets["kafka-bpm-sdp-sa-id"].secret_data, ""),
        "serviceSAName"            = try(data.google_secret_manager_secret_version_access.kafka_secrets["kafka-bpm-sdp-sa-name"].secret_data, ""),
        "serviceSAApiKeyId"        = try(data.google_secret_manager_secret_version_access.kafka_secrets["kafka-tf-bpm-sdp-api-key-id"].secret_data, ""),
        "serviceSAApiKeySecret"    = try(data.google_secret_manager_secret_version_access.kafka_secrets["kafka-tf-bpm-sdp-api-key-secret"].secret_data, ""),
        "schemaRegistryEndpoint"   = data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-schema-registry-endpoint"].secret_data,
        "schemaApiKeyId"           = try(data.google_secret_manager_secret_version_access.kafka_secrets["kafka-tf-bpm-sdp-sr-key-id"].secret_data, ""),
        "schemaApiKeySecret"       = try(data.google_secret_manager_secret_version_access.kafka_secrets["kafka-tf-bpm-sdp-sr-key-secret"].secret_data, ""),
        "clusterRestEndpoint"      = data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-rest-endpoint"].secret_data,
        "clusterId"                = jsondecode(data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-id"].secret_data).clusterId,
        "clusterBootstrapEndpoint" = data.google_secret_manager_secret_version_access.kafka_cluster_config["kafka-cluster-bootstrap-endpoint"].secret_data,
        "clusterBootstrapScheme"   = "SASL_SSL"
      })
    }
  } : {}
}