
resource "pingone_application" "starayx" {
  environment_id = var.STARAYX_PINGONE.environment_id
  name           = var.resource_name
  enabled        = true
  oidc_options {
    type                        = "SERVICE"
    grant_types                 = ["CLIENT_CREDENTIALS"]
    token_endpoint_authn_method = "CLIENT_SECRET_POST"
  }
  lifecycle {
    create_before_destroy = false
  }
}

resource "pingone_resource" "starayx" {
  environment_id                  = var.STARAYX_PINGONE.environment_id
  name                            = "StarAyx PDP Registration Service ${upper(var.TARGET_CLOUD)}/${var.resource_name}"
  description                     = "AAC Registration Service API which is used to register Data planes and other Edge components with the Control plane"
  access_token_validity_seconds   = 600
  introspect_endpoint_auth_method = "CLIENT_SECRET_POST"
  lifecycle {
    create_before_destroy = false
  }
}


resource "pingone_resource_scope" "starayx" {
  environment_id = var.STARAYX_PINGONE.environment_id
  resource_id    = pingone_resource.starayx.id
  name           = var.tfworkspace
  lifecycle {
    create_before_destroy = false
  }
}

resource "pingone_application_resource_grant" "starayx" {
  environment_id = var.STARAYX_PINGONE.environment_id
  application_id = pingone_application.starayx.id

  resource_name = pingone_resource.starayx.name

  scope_names = [
    pingone_resource_scope.starayx.name,
  ]

  lifecycle {
    create_before_destroy = false
  }
}


resource "pingone_application" "starayx_auth" {
  environment_id = var.STARAYX_PINGONE.environment_id
  name           = "${var.resource_name}_starayx_auth"
  description    = "PingOne App for StarAyx auth"
  enabled        = true
  oidc_options {
    type                        = "SERVICE"
    grant_types                 = ["CLIENT_CREDENTIALS"]
    token_endpoint_authn_method = "CLIENT_SECRET_POST"
  }
  lifecycle {
    create_before_destroy = false
  }
}

resource "pingone_resource" "starayx_auth" {
  environment_id                  = var.STARAYX_PINGONE.environment_id
  name                            = "StarAyx PDP Gateway Service ${upper(var.TARGET_CLOUD)}/${var.last_two_blocks_tfworkspace}"
  access_token_validity_seconds   = 600
  introspect_endpoint_auth_method = "CLIENT_SECRET_POST"
  lifecycle {
    create_before_destroy = false
  }
}


resource "pingone_resource_scope" "starayx_auth" {
  environment_id = var.STARAYX_PINGONE.environment_id
  resource_id    = pingone_resource.starayx_auth.id
  name           = var.tfworkspace
  lifecycle {
    create_before_destroy = false
  }
}

resource "pingone_application_resource_grant" "starayx_auth" {
  environment_id = var.STARAYX_PINGONE.environment_id
  application_id = pingone_application.starayx_auth.id

  resource_name = pingone_resource.starayx_auth.name

  scope_names = [
    pingone_resource_scope.starayx_auth.name,
  ]

  lifecycle {
    create_before_destroy = false
  }
}

