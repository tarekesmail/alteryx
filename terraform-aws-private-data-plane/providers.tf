terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.css]
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    helm = {
      source                = "hashicorp/helm"
      version               = "~> 2.7"
      configuration_aliases = [helm.cp, helm.mp]
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 1.32"
    }
    pingone = {
      source  = "pingidentity/pingone"
      version = "0.21.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "17.7.0"
    }
    restapi = {
      source  = "mastercard/restapi"
      version = "~> 1.18"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "kubernetes" {
  alias                  = "blue"
  host                   = local.CONTEXT.host
  cluster_ca_certificate = local.CONTEXT.cluster_ca_certificate
  token                  = local.CONTEXT.token
}

provider "kubernetes" {
  alias                  = "cp"
  cluster_ca_certificate = base64decode(data.google_container_cluster.cp_cluster.master_auth.0.cluster_ca_certificate)
  host                   = "https://${data.google_container_cluster.cp_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
  alias = "cp"
  kubernetes {
    cluster_ca_certificate = base64decode(data.google_container_cluster.cp_cluster.master_auth.0.cluster_ca_certificate)
    host                   = "https://${data.google_container_cluster.cp_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
  }
}

provider "helm" {
  alias = "mp"
  kubernetes {
    cluster_ca_certificate = base64decode(data.google_container_cluster.mp_cluster.master_auth.0.cluster_ca_certificate)
    host                   = "https://${data.google_container_cluster.mp_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
  }
}

provider "aws" {
  region = var.AWS_DATAPLANE_REGION
}

provider "aws" {
  alias  = "dpaccount"
  region = var.AWS_DATAPLANE_REGION
}

provider "aws" {
  alias               = "css"
  region              = var.AWS_DATAPLANE_REGION
  allowed_account_ids = local.struct[local.structure].allowed_account_ids
  access_key          = try(var.CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS.AWS_ACCESS_KEY_ID, null)
  secret_key          = try(var.CLOUD_EXECUTION_AWS_AMI_SHARING_CREDS.AWS_SECRET_ACCESS_KEY, null)
}

provider "pingone" {
  region         = var.PINGONE_WORKER_APPLICATION_REGION
  environment_id = var.PINGONE_WORKER_APPLICATION_ENVIRONMENTID
  client_id      = var.PINGONE_WORKER_APPLICATION_CLIENTID
  client_secret  = var.PINGONE_WORKER_APPLICATION_CLIENTSECRET
}

provider "aws" {
  alias               = "cn-us-east"
  region              = "us-east-1"
  allowed_account_ids = [local.struct[local.structure].core_network_account]
  access_key          = var.CORE_NETWORK_CREDENTIALS[local.structure].AWS_ACCESS_KEY_ID
  secret_key          = var.CORE_NETWORK_CREDENTIALS[local.structure].AWS_SECRET_ACCESS_KEY
  assume_role {
    role_arn = "arn:aws:iam::${local.struct[local.structure].core_network_account}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias               = "cn-eu-west"
  region              = "eu-west-1"
  allowed_account_ids = [local.struct[local.structure].core_network_account]
  access_key          = var.CORE_NETWORK_CREDENTIALS[local.structure].AWS_ACCESS_KEY_ID
  secret_key          = var.CORE_NETWORK_CREDENTIALS[local.structure].AWS_SECRET_ACCESS_KEY
  assume_role {
    role_arn = "arn:aws:iam::${local.struct[local.structure].core_network_account}:role/OrganizationAccountAccessRole"
  }
}

provider "gitlab" {
  base_url = "https://git.alteryx.com/api/v4/"
  token    = var.futurama_private_gitlab_token
}

# DEPRECATED: For Upwind integration cleanup only
# TODO: Remove once all Upwind resources are cleaned up from all environments
#For Upwind integration (log exporter module)
provider "restapi" {
  alias                = "integration"
  uri                  = "https://integration.upwind.io/v1/organizations"
  write_returns_object = true

  headers = {
    "Authorization" : "Bearer ${local.access_token}"
    "Content-Type" = "application/json"
  }
  update_method = "PATCH"
}