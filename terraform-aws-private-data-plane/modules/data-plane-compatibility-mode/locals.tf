locals {
  cefd_resource_name = "${var.resource_name}-${var.name}"

  cefd_instance_types_per_region = {
    "ap-east-1"      = "m6i.4xlarge",
    "ap-northeast-1" = "m5a.4xlarge",
    "ap-northeast-2" = "m5a.4xlarge",
    "ap-south-1"     = "m5a.4xlarge",
    "ap-southeast-1" = "m5a.4xlarge",
    "ap-southeast-2" = "m5a.4xlarge",
    "ca-central-1"   = "m5a.4xlarge",
    "eu-central-1"   = "m5a.4xlarge",
    "eu-north-1"     = "m6i.4xlarge",
    "eu-west-1"      = "m5a.4xlarge",
    "eu-west-2"      = "m5a.4xlarge",
    "eu-west-3"      = "m5a.4xlarge",
    "me-south-1"     = "m6i.4xlarge",
    "sa-east-1"      = "m5a.4xlarge",
    "us-east-1"      = "m5a.4xlarge",
    "us-east-2"      = "m5a.4xlarge",
    "us-west-1"      = "m5a.4xlarge",
    "us-west-2"      = "m5a.4xlarge",
  }

  cefd_instance_type = lookup(local.cefd_instance_types_per_region, var.region, "m5a.4xlarge")


  # https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html#sysman-setting-up-vpc-create
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint#vpc_endpoint_type
  VPC_ENDPOINTS = var.DISABLE_VPC_ENDPOINTS ? {} : {
    ("com.amazonaws.${var.region}.ssm")            = "Interface"
    ("com.amazonaws.${var.region}.ssmmessages")    = "Interface"
    ("com.amazonaws.${var.region}.ec2messages")    = "Interface"
    ("com.amazonaws.${var.region}.secretsmanager") = "Interface"
    # ("com.amazonaws.${var.region}.kms")            = "Interface"
    # ("com.amazonaws.${var.region}.s3")             = "Gateway"
  }

  TAGS = merge(var.tags, {
    Name                    = local.cefd_resource_name,
    Teleport_Windows_Target = "true"
  })

  GOOGLE_SECRET_MANAGER_CONTROL_PLANE_KAFKA_SECRETS = toset([
    "kafka-topic-jobstatus-name",
    "kafka-topic-renderstatus-name",
    "kafka-cluster-rest-endpoint",
    "kafka-sa-api-key-id",
    "kafka-sa-api-key-secret",
    "kafka-schema-registry-sa-api-key-id",
    "kafka-schema-registry-sa-api-key-secret",
    "kafka-cluster-schema-registry-endpoint"
  ])

  ENABLE_CEFD_SCALING = var.CLOUD_EXECUTION_MAX_SCALING > 2
  # jsondecode function here should probably be wrapped in a try instead of colaesce as we validate the version regex, but not the target cloud 
  # so technically this value could not exist and coalesce does not handle errors
  CLOUD_EXECUTION_LAMBDA_VERSION = coalesce(jsondecode(var.CLOUD_EXECUTION_AUTOSCALING_VERSIONS)[var.TARGET_CLOUD], "1.0.5")
  CEFD_LAMBDA_S3_BUCKET          = var.FUTURAMA_STRUCTURE == "lowers" ? "dev-css-public-storage" : "prod-css-public-storage"

  CONTAINER_ROLE_ARN = try(aws_iam_role.container_role[0].arn, "")
}