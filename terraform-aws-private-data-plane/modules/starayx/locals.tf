locals {

  TAGS = merge(var.tags, {
    Name = var.name,
  })

  pingone_merged_config = merge(var.STARAYX_PINGONE, {
    client_id     = pingone_application.starayx.oidc_options[0].client_id,
    client_secret = pingone_application.starayx.oidc_options[0].client_secret
  })

  pingone_config_starayx_auth = {
    apiURL = "https://auth.pingone.com/${var.STARAYX_PINGONE.environment_id}",
    scope  = var.tfworkspace
  }

  teleport_token_name = "starayx-pdp-${var.cluster_name}"

  teleport_config = yamlencode({
    "version" : "v3",
    "teleport" : {
      "nodename" : "starayx-${var.resource_name}",
      "data_dir" : "/var/lib/teleport",
      "join_params" : {
        "token_name" : "/etc/teleport-token.txt",
        "method" : "iam"
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
      "enabled" : "yes",
      "enhanced_recording" : {
        "enabled" : "true"
      },
      "labels" : {
        "node_name" : "starayx-${var.resource_name}"
        "aac_workspace_id" : "${var.SEGMENTID}",
        "cloud_region" : "${var.region}",
        "cloud_id" : "${var.accountid}",
        "cloud" : "AWS",
        "terraform_cloud_workspace_id" : "${var.tfworkspace}",
        "control_plane_name" : "${var.control_plane_name}",
        "domain_name" : "${var.control_plane_domain}"
      },
      "commands" : [
        {
          "name" : "hostname",
          "command" : [
            "hostname"
          ],
          "period" : "1m0s"
        }
      ]
    },
    "proxy_service" : {
      "enabled" : "no"
    }
  })
}


