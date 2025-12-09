data "aws_ssoadmin_instances" "this" {

  provider = aws.presidio_root
}

data "aws_ssoadmin_permission_set" "admin" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = "AdministratorAccess"

  provider = aws.presidio_root
}

data "aws_ssoadmin_permission_set" "audit" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = "ViewOnlyAccess"

  provider = aws.presidio_root
}

data "aws_ssoadmin_permission_set" "security" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = "SecurityAccess"

  provider = aws.presidio_root
}

data "aws_identitystore_group" "admin" {
  for_each = toset(local.sso_groups.admin)

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }

  provider = aws.presidio_root
}

data "aws_identitystore_group" "audit" {
  for_each          = toset(local.sso_groups.audit)
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }

  provider = aws.presidio_root
}

data "aws_identitystore_group" "security" {
  for_each          = toset(local.sso_groups.security)
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }

  provider = aws.presidio_root
}

resource "aws_ssoadmin_account_assignment" "admin" {
  for_each           = toset(local.sso_groups.admin)
  instance_arn       = data.aws_ssoadmin_permission_set.admin.instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.admin.arn
  principal_id       = data.aws_identitystore_group.admin[each.value].group_id
  principal_type     = "GROUP"
  target_id          = module.dp_account.id # Dynamically assign the account ID
  target_type        = "AWS_ACCOUNT"

  provider = aws.presidio_root
}

resource "aws_ssoadmin_account_assignment" "audit" {
  for_each           = toset(local.sso_groups.audit)
  instance_arn       = data.aws_ssoadmin_permission_set.audit.instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.audit.arn
  principal_id       = data.aws_identitystore_group.audit[each.value].group_id
  principal_type     = "GROUP"
  target_id          = module.dp_account.id
  target_type        = "AWS_ACCOUNT"

  provider = aws.presidio_root
}

resource "aws_ssoadmin_account_assignment" "security" {
  for_each           = toset(local.sso_groups.security)
  instance_arn       = data.aws_ssoadmin_permission_set.security.instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.security.arn
  principal_id       = data.aws_identitystore_group.security[each.value].group_id
  principal_type     = "GROUP"
  target_id          = module.dp_account.id
  target_type        = "AWS_ACCOUNT"

  provider = aws.presidio_root
}
