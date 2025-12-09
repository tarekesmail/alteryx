locals {

  TAGS = merge(var.tags, {
    Name = var.name,
  })

  tcp_k8s_endpoint    = try(replace(var.cluster_endpoint, "https://", ""), null)
  teleport_token_name = "pdp-${var.cluster_name}"

  teleport_config = yamlencode({
    "version" : "v3",
    "teleport" : {
      "nodename" : "teleport-${var.resource_name}",
      "data_dir" : "/var/lib/teleport",
      "join_params" : {
        "token_name" : "/etc/teleport-token.txt",
        "method" : "token"
      },
      "proxy_server" : "${var.teleport_proxy_uri}",
      "log" : {
        "output" : "stderr",
        "severity" : "INFO",
        "format" : {
          "output" : "text"
        }
      },
      "ca_pin" : "",
      "diag_addr" : ""
    },
    "auth_service" : {
      "enabled" : "no"
    },
    "ssh_service" : {
      "enabled" : "no",
    },
    "app_service" : {
      "enabled" : "yes",
      "apps" : [
        {
          "name" : "pdp-aws-k8sapi-${var.cluster_name}",
          "uri" : "tcp://${local.tcp_k8s_endpoint}:443",
          "labels" : {
            "tcp_app" : "pdp-argo"
            "node_name" : "teleport-${var.resource_name}"
            "aac_workspace_id" : "${var.SEGMENTID}",
            "cloud_region" : "${var.control_plane_region}",
            "cloud_id" : "${var.accountid}",
            "cloud" : "AWS",
            "terraform_cloud_workspace_id" : "${var.tfworkspace}",
            "control_plane_name" : "${var.control_plane_name}",
            "domain_name" : "${var.control_plane_domain}"
          }
        }
      ]

    },
    "proxy_service" : {
      "enabled" : "no"
    }
  })

  teleport_instance_types_per_region = {
    "ap-east-1"      = "m6i.4xlarge"
    "ap-northeast-1" = "m5a.4xlarge"
    "ap-northeast-2" = "m5a.4xlarge"
    "ap-south-1"     = "m5a.4xlarge"
    "ap-southeast-1" = "m5a.4xlarge"
    "ap-southeast-2" = "m5a.4xlarge"
    "ca-central-1"   = "m5a.4xlarge"
    "eu-central-1"   = "m5a.4xlarge"
    "eu-north-1"     = "m6i.4xlarge"
    "eu-west-1"      = "m5a.4xlarge"
    "eu-west-2"      = "m5a.4xlarge"
    "eu-west-3"      = "m5a.4xlarge"
    "me-south-1"     = "m6i.4xlarge"
    "sa-east-1"      = "m5a.4xlarge"
    "us-east-1"      = "m5a.4xlarge"
    "us-east-2"      = "m5a.4xlarge"
    "us-west-1"      = "m5a.4xlarge"
    "us-west-2"      = "m5a.4xlarge"
  }

  teleport_instance_type = lookup(local.teleport_instance_types_per_region, var.region, "m5a.4xlarge")
}
