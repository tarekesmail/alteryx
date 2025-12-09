terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.58.0"
      #      version               = ">= 5.34.0"
      configuration_aliases = [aws.css]
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
    confluent = {
      source  = "confluentinc/confluent"
      version = ">= 1.32.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}


