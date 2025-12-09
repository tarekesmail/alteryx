data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_secretsmanager_secret_version" "EKS_CONNECTION_TOKEN" {
  count      = local.k8s_option_enabled ? 1 : 0
  secret_id  = local.RUNNER_SERVICE_OAUTH_TOKEN
  depends_on = [shell_script.oauth_token_secret]
}

# discover vpc_id when it is not set
data "aws_vpc" "selected" {
  filter {
    name   = "tag:AACResource"
    values = ["aac_vpc"]
  }
}

data "aws_region" "current" {}

# TODO remove this part, after teleport module is updated :
data "aws_ami" "teleport_agent_base_ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = [local.teleport_agent_base_ami_name]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "hypervisor"
    values = ["xen"]
  }

  provider = aws.css
}


#TODO remove this part, after teleport module is updated :
data "shell_script" "private_eks_cluster" {
  lifecycle_commands {
    read = file("${path.module}/scripts/read-private-eks-cluster.sh")
  }
  environment = {
    REGION = "${local.region}"
  }
}

locals {
  region = data.aws_region.current.name
  # TODO: why are there two different locals for the same value?
  account_id   = data.aws_caller_identity.current.id
  account_name = data.aws_caller_identity.current.id
  # TODO: why are we assigning vars to locals when the value is unchanged?
  control_plane_name        = var.CONTROL_PLANE_NAME
  control_plane_region      = var.CONTROL_PLANE_REGION
  domain_name               = var.CONTROL_PLANE_DOMAIN
  structure                 = var.FUTURAMA_STRUCTURE
  append_unique_name        = join("-", slice(tolist(split("-", var.TF_CLOUD_WORKSPACE)), max(length(split("-", var.TF_CLOUD_WORKSPACE)) - 2, 0), length(split("-", var.TF_CLOUD_WORKSPACE))))
  resource_name             = "aac-${local.append_unique_name}"
  data_plane_region         = data.aws_region.current.name
  data_plane_vpc_id         = coalesce(var.AWS_DATAPLANE_VPC_ID, try(one(data.aws_vpc.selected).id, var.AWS_DATAPLANE_VPC_ID))
  data_plane_aws_account_id = data.aws_caller_identity.current.account_id

  # ---------------------
  # Data Plane Options
  # ---------------------

  k8s_options = {
    app_builder    = var.ENABLE_APPBUILDER
    auto_insights  = var.ENABLE_AUTO_INSIGHTS
    automl         = var.ENABLE_AML
    desginer_cloud = var.ENABLE_DC
    emr_serverless = var.ENABLE_EMR_SERVERLESS
  }

  all_options = merge({
    cloud_execution = var.ENABLE_CLOUD_EXECUTION
  }, local.k8s_options)

  # ------------------------
  # Data Plane Type Checks
  # ------------------------

  is_pdp        = var.DATAPLANE_TYPE == "private"
  is_ddp        = var.DATAPLANE_TYPE == "dedicated"
  is_cefdshared = var.DATAPLANE_TYPE == "cefdshared"

  # ----------------------------------
  # Consolidated Toggles
  # ----------------------------------

  k8s_option_enabled = anytrue(values(local.k8s_options))
  any_option_enabled = anytrue(values(local.all_options))
  ENABLE_BPM         = alltrue([var.ENABLE_BRIDGE_PROXY_MANAGER, local.is_cefdshared, local.any_option_enabled])
  ENABLE_COREDNS     = local.is_cefdshared
  enable_juicefs     = anytrue([var.ENABLE_DC, var.ENABLE_APPBUILDER])

  # This splits the domain name into its component parts based on the period (.) character.
  # slice removes the last two parts of the domain name, which are typically the main domain and top-level domain (e.g., bender.rocks).
  # join combines the remaining parts back into a subdomain string.
  subdomain_name = join(".", slice(split(".", var.CONTROL_PLANE_DOMAIN), 0, length(split(".", var.CONTROL_PLANE_DOMAIN)) - 2))

  eks_api_access = data.shell_script.private_eks_cluster.output["EKS_API_ACCESS"]

  common_labels = merge(local.common_tags, {
    "tfworkspace" = var.TF_CLOUD_WORKSPACE
    }
  )

  control_plane_nat_ips = formatlist("%s/32", data.terraform_remote_state.control_plane.outputs.control_plane_nat_ips)

  # CP starayx wireguard public ip(s) from the instances running on starayx mig
  starayx_control_plane_ips = formatlist("%s/32", data.terraform_remote_state.control_plane.outputs.starayx.wireguard.public_ips)

  # git_alteryx_ips                          = module.alteryx_ips.gitlab_ip_addresses #formatlist("%s/32", data.terraform_remote_state.control_plane.outputs.gitlab_nat_ips)
  # TODO - Workaround connectivity issues connecting to gitlab modules from tfcloud
  gitlab_ip_addresses                      = ["44.227.135.252/32", "44.225.123.94/32", "104.193.47.0/24", "66.35.44.241/32", "74.199.216.160/27", "54.188.210.240/32"]
  git_alteryx_ips                          = var.DEPLOY_PLATFORM == "tfayx" ? local.gitlab_ip_addresses : []
  eks_cluster_endpoint_public_access_cidrs = concat(local.control_plane_nat_ips, local.tf_agent_ips, local.git_alteryx_ips)

  # Feature toggles to send with ArgoCD registration
  cloud_exec_toggle     = var.ENABLE_CLOUD_EXECUTION ? "ENABLED" : "DISABLED"
  emr_serverless_toggle = var.ENABLE_EMR_SERVERLESS ? "ENABLED" : "DISABLED"
  designer_cloud_toggle = var.ENABLE_DC ? "ENABLED" : "DISABLED"
  automl_toggle         = var.ENABLE_AML ? "ENABLED" : "DISABLED"
  auto_insights_toggle  = var.ENABLE_AUTO_INSIGHTS ? "ENABLED" : "DISABLED"
  app_builder_toggle    = var.ENABLE_APPBUILDER ? "ENABLED" : "DISABLED"
  # In some cases we need an "OR" condition in the ArgoCD matchlabel area but ArgoCD doesn't support it, so we need to aggregate them into a single toggle
  resource_conductor_toggle = (var.ENABLE_APPBUILDER || var.ENABLE_DC) ? "ENABLED" : "DISABLED"

  management_plane_name   = var.MANAGEMENT_PLANE_NAME
  management_plane_region = var.MANAGEMENT_PLANE_REGION

  argocd_bender_server = "argocd-bender-server"

  # TODO remove this part, after teleport module is updated :
  teleport_agent_base_ami_name = "al2023-ami-2*kernel-6.1*"
  teleport_agent_base_ami      = data.aws_ami.teleport_agent_base_ami.id

  pdp_eks_name   = format("%s-%s", local.resource_name, "eks")
  s3_bucket_name = "${local.resource_name}-${local.region}"

  s3_juicefs_bucket_name = "${local.resource_name}-${local.region}-juicefs"

  trusted_user           = "trusted_user-${local.account_name}"
  trusted_user_role_name = "${local.resource_name}-role_trusted_user"
  policy_assume_role     = "${local.resource_name}-policy_assume_role"

  common_tags = {
    workspaceID = var.SEGMENTID
    AACResource = "aac"
    tfworkspace = var.TF_CLOUD_WORKSPACE
  }
  # Adding common_tags_cp for GCP labels since it's regular expression doesn't allow uppercase letters.
  common_tags_cp = {
    workspaceid = var.SEGMENTID
    aacresource = "aac"
    tfworkspace = var.TF_CLOUD_WORKSPACE
  }

  PDP_GAR_USERNAME = "_json_key_base64"
  PDP_GAR_PASSWORD = local.k8s_option_enabled ? google_service_account_key.pdp_gar_sa_key[0].private_key : ""
  # gar auth secret for dockerconfigjson/imagepullsecrets docker format
  PDP_GAR_SA_KEY = {
    "${local.resource_name}-pdp-gar-auth" = {
      description = "pdp gar auth json for for dockerconfigjson/imagepullsecrets"
      secret_key_value = jsonencode({
        auths = {
          "us-docker.pkg.dev" = {
            username = local.PDP_GAR_USERNAME
            password = local.PDP_GAR_PASSWORD
          }
          "eu-docker.pkg.dev" = {
            username = local.PDP_GAR_USERNAME
            password = local.PDP_GAR_PASSWORD
          }
          "gcr.io" = {
            username = local.PDP_GAR_USERNAME
            password = local.PDP_GAR_PASSWORD
          }
        }
      })
    }
  }

  juicefs_config = {
    "juicefs_config" = {
      description = "JuiceFS Config"
      secret_key_value = jsonencode({
        name    = "juicefs"
        metaurl = "redis://redis-sentinel.conductor.svc.cluster.local:6379/2"
        storage = "s3"
        bucket  = "https://${local.s3_juicefs_bucket_name}.s3.${data.aws_region.current.name}.amazonaws.com"
        envs : "{\"AWS_REGION\": \"${data.aws_region.current.name}\" }"
      })
    }
  }

  juicefs_config_new = {
    "${local.resource_name}-juicefs" = {
      description = "JuiceFS Config"
      secret_key_value = jsonencode({
        name    = "juicefs"
        metaurl = "redis://redis-sentinel.conductor.svc.cluster.local:6379/2"
        storage = "s3"
        bucket  = "https://${local.s3_juicefs_bucket_name}.s3.${data.aws_region.current.name}.amazonaws.com"
        envs : "{\"AWS_REGION\": \"${data.aws_region.current.name}\" }"
      })
    }
  }

  PACT_KEY = {
    "pact-key" = {
      description      = "Pact Key"
      secret_key_value = data.google_secret_manager_secret_version.pact-key.secret_data
    },
    "${local.resource_name}-pact-key" = {
      description      = "Pact Key"
      secret_key_value = data.google_secret_manager_secret_version.pact-key.secret_data
    }
  }

  # Using this instead of the new_secret_map since there is only 1 datadog api key for all envs.
  decoded_secrets = jsondecode(var.SECRETS)
  datadog_api_key = local.decoded_secrets["datadog-api-key"]

  # sentinelone tokens for the futurama environment
  sentinelone_site_tokens    = jsondecode(data.gitlab_group_variable.sentinelone_site_tokens.value)
  futurama_sentinelone_token = local.sentinelone_site_tokens["futurama"]

  # update secret object received via var.SECRETS with local.resource_name prefix
  new_secret_map = jsonencode({
    for key, value in local.decoded_secrets : "${local.resource_name}-${key}" => value
  })

  INPUT_SECRETS = merge(
    # ci/cd gitlab var secrets
    jsondecode(local.new_secret_map),
    # add more internal secrets
    local.juicefs_config,
    local.juicefs_config_new
  )

  CONTEXT = local.k8s_option_enabled ? {
    host                   = module.eks_blue[0].CONTEXT["host"],
    cluster_ca_certificate = module.eks_blue[0].CONTEXT["cluster_ca_certificate"],
    token                  = module.eks_blue[0].CONTEXT["token"],
    } : {
    host                   = null,
    cluster_ca_certificate = null,
    token                  = null,
  }

  tf_agent_ips = formatlist("%s/32", concat(
    [for nat in data.aws_nat_gateways.ngws_east.ids : data.aws_nat_gateway.core_network_nat_east[nat].public_ip],
    [for nat in data.aws_nat_gateways.ngws_eu.ids : data.aws_nat_gateway.core_network_nat_eu[nat].public_ip]
  ))

  teleport_aws_autoscaling = {
    max_size       = var.TELEPORT_AWS_AUTOSCALING.max_size
    min_size       = local.eks_api_access == "private" ? 1 : 0
    instance_types = var.TELEPORT_AWS_AUTOSCALING.instance_types
  }

  struct = {
    lowers = {
      teleport_cluster                = "teleport.bender.rocks"
      teleport_proxy_uri              = "agent-traffic.teleport.bender.rocks:443"
      teleport_proxy_host             = "agent-traffic.teleport.bender.rocks"
      allowed_account_ids             = ["715489977051", "066115427626"]
      db_multi_az                     = false
      backup_policy_enabled           = false
      memorydb_replica_per_shard      = 0
      memorydb_type                   = "db.t4g.medium"
      enable_memorydb                 = true
      core_network_account            = "081866812882"
      enable_credential_service_infra = true
    }
    uppers = {
      teleport_cluster                = "mgmt.alteryxcloud.com"
      teleport_proxy_uri              = "agent-traffic.mgmt.alteryxcloud.com:443"
      teleport_proxy_host             = "agent-traffic.mgmt.alteryxcloud.com"
      allowed_account_ids             = ["715489977051", "066115427626"]
      db_multi_az                     = true
      backup_policy_enabled           = true
      memorydb_replica_per_shard      = 1
      memorydb_type                   = "db.r7g.large"
      enable_memorydb                 = var.CONTROL_PLANE_NAME == "c-us-e4-a00004"
      core_network_account            = "335015696019"
      enable_credential_service_infra = true
    }
  }
}
