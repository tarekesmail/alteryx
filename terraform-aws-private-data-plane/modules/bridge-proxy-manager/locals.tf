locals {
  full_name = "${var.resource_name}-${var.name}"

  TAGS = merge(var.tags, {
    Name = "bridge-proxy-manager",
  })

  teleport_token_name = "bpm-${var.resource_name}"

  teleport_config = yamlencode({
    "version" : "v3",
    "teleport" : {
      "nodename" : "bpm-${var.resource_name}",
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
        "node_name" : "starayx-bpm-${var.resource_name}"
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