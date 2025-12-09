terraform {
  required_providers {
    kubernetes = {
      source                = "hashicorp/kubernetes"
      version               = "2.21.1"
      configuration_aliases = [kubernetes.cp]
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
  }
}