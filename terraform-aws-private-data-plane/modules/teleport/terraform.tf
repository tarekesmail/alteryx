terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.58.0"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
  }
}

