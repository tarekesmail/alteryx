locals {
  COMPATIBILITY_MODE_APPSETTINGS_SECRET_KEY = "${local.cefd_resource_name}-appsettings"
  KAFKA_CLOUD_EXECUTION_API_SECRET_KEY      = "${var.resource_name}-kafka-cloudexecution-job-api-key"

  CLOUD_EXECUTION_SECRETS_MANAGER_SECRETS = {
    (local.KAFKA_CLOUD_EXECUTION_API_SECRET_KEY) = {
      description = "SA API KEY for accessing the Kafka Topics: ${var.control_plane_name}-cloudexecution-${var.SEGMENTID}-*"
      secret_string = jsonencode({
        id     = one(confluent_api_key.workspace_cloudexecution).id
        secret = one(confluent_api_key.workspace_cloudexecution).secret

        # wrapping this in a try because it is possible for this data source to not be created
        endpoint = try(data.google_secret_manager_secret_version_access.kafka["kafka-cluster-rest-endpoint"].secret_data, "")
      })
    }

    (local.COMPATIBILITY_MODE_APPSETTINGS_SECRET_KEY) = {
      description = local.COMPATIBILITY_MODE_APPSETTINGS_SECRET_KEY
      # [cnotarianni] this should use jsonencode per TF best practices
      secret_string = <<JSON
  {
    "BootstrapServers": "${one(data.confluent_kafka_cluster.control_plane_cluster).bootstrap_endpoint}",
    "MessageTimeoutMs": "300000",
    "SaslMechanism": "PLAIN",
    "SaslPassword": "${one(confluent_api_key.workspace_cloudexecution).secret}",
    "SaslUsername": "${one(confluent_api_key.workspace_cloudexecution).id}",
    "SecurityProtocol": "SASL_SSL",
    "SchemaUrl": "${data.google_secret_manager_secret_version_access.kafka["kafka-cluster-schema-registry-endpoint"].secret_data}",
    "SchemaUsername": "${data.google_secret_manager_secret_version_access.kafka["kafka-schema-registry-sa-api-key-id"].secret_data}",
    "SchemaPassword": "${data.google_secret_manager_secret_version_access.kafka["kafka-schema-registry-sa-api-key-secret"].secret_data}",
    "WorkspaceId": "${var.SEGMENTID}",
    "ConcurrentRuns": 3,
    "ClusterName": "${one(data.confluent_kafka_cluster.control_plane_cluster).display_name}",
    "HealthCheckInterval": "00:01:00",
    "MemoryLimitBytes": "4294967296",
    "WorkerTimeoutSeconds": "${var.worker_timeout}",
    "EnableCoreDNS": "${var.ENABLE_COREDNS}",
    "LaunchTemplateName": "${aws_launch_template.compatibility_mode.name}",
    "AutoScalingGroupName": "${aws_autoscaling_group.compatibility_mode.name}",
    "CloudProvider": "${var.TARGET_CLOUD}",
    "VPCResolverIP": "${local.vpc_resolver_ip}",
    "ConcurrentRenderRuns": "3",
    "Logging": {
      "Console": true,
      "File": {
        "LogFilePath": "c:/Logs/ExecutionHost_.log"
      }
    },
    "MajorEngineVersion": "${var.CLOUD_EXECUTION_ENGINE_VERSION}",
    "ContainerArn": "${local.CONTAINER_ROLE_ARN}",
    "CefdLatestImage": "${local.CLOUD_EXECUTION_SELECTED_AMI_NAME}",
    "EnableCloudExecutionCustomDrivers": "${var.ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER}",
    "EnableDCMService": "${var.ENABLE_DCM_SERVICE}",
    "DataplaneType": "${var.DATAPLANE_TYPE}",
    "FuturamaEnvironment": "${var.FUTURAMA_STRUCTURE}",
    "CefdAutoScalingVersion": "${local.CLOUD_EXECUTION_LAMBDA_VERSION}",
    "MAX_SCALING": "${var.CLOUD_EXECUTION_MAX_SCALING}"
  }
  JSON
    }
  }
}
