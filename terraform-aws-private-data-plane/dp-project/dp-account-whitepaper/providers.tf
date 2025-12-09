provider "aws" {
  alias  = "presidio_root"
  region = local.core_region
  assume_role {
    role_arn = "arn:aws:iam::${local.presidio_root_account_id}:role/${local.presidio_role}"
  }
  access_key = var.PRESIDIO_AWS_ACCESS_KEY_ID
  secret_key = var.PRESIDIO_AWS_SECRET_ACCESS_KEY
}

provider "aws" {
  alias  = "dpaccount"
  region = local.account_region
  assume_role {
    role_arn = "arn:aws:iam::${local.account_id}:role/OrganizationAccountAccessRole"
  }
  access_key = var.PRESIDIO_AWS_ACCESS_KEY_ID
  secret_key = var.PRESIDIO_AWS_SECRET_ACCESS_KEY
}

provider "aws" {
  region     = local.core_region
  access_key = var.PRESIDIO_AWS_ACCESS_KEY_ID
  secret_key = var.PRESIDIO_AWS_SECRET_ACCESS_KEY
}