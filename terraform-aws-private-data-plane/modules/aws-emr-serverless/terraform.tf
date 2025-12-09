terraform {

  required_version = ">= 1.3.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.58.0"
      #      version = ">= 5.34.0"
    }
  }
}
