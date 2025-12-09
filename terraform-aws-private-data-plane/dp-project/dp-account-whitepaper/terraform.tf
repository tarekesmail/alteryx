terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "17.7.0"
    }
  }
}