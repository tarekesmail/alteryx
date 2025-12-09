terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.0"
    }
    shell = {
      source = "scottwinkler/shell"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.58.0"
    }
  }
}

