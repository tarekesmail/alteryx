![Terraform](https://lgallardo.com/images/terraform.jpg)
# terraform-aws-secrets-manager

Terraform module to create [Amazon Secrets Manager](https://aws.amazon.com/secrets-manager/) resources.

AWS Secrets Manager helps you protect secrets needed to access your applications, services, and IT resources. The service enables you to easily rotate, manage, and retrieve database credentials, API keys, and other secrets throughout their lifecycle.

## Examples


## Usage

You can create secrets for plain texts, keys/values and binary data:

### Plain text secrets

```
module "secrets-manager-1" {

  source = "this_module"

  secrets = {
    secret-1 = {
      description             = "My secret 1"
      recovery_window_in_days = 7
      secret_key_value           = "This is an example"
    },
    secret-2 = {
      description             = "My secret 2"
      recovery_window_in_days = 7
      secret_key_value           = "This is another example"
    }
  }

  tags = {
    Owner       = "DevOps team"
    Environment = "dev"
    Terraform   = true

  }
}
```

### Key/Value secrets

```
module "secrets-manager-2" {

  source = "this_module"

  secrets = {
    secret-kv-1 = {
      description = "This is a key/value secret"
      secret_key_value = {
        key1 = "value1"
        key2 = "value2"
      }
      recovery_window_in_days = 7
    },
    secret-kv-2 = {
      description = "Another key/value secret"
      secret_key_value = {
        username = "user"
        password = "topsecret"
      }
      tags = {
        app = "web"
      }
      recovery_window_in_days = 7
    },
  }

  tags = {
    Owner       = "DevOps team"
    Environment = "dev"
    Terraform   = true
  }
}

```

### Binary secrets

## when the contents of secrets are b64 encoded

module "secrets-manager-2" {

  source = "this_module"

  secrets = {
    # binary
    secret_b64_= {
      description = "This base64 encoded secret that will create a SM binary secret"
      secret_key_value = "SEVMTE9PT08="
      recovery_window_in_days = 7
    },

    # json
    secret-kv-2 = {
      description = "Another key/value secret"
      secret_key_value = {
        username = "user"
        password = "topsecret"
      }
      tags = {
        app = "web"
      }
      recovery_window_in_days = 7
    },
    # simple text
    secret-kv-3 = {
      description = "Another key/value secret"
      secret_key_value = "SOME TEXT STRING"
      tags = {
        app = "web"
      }
      recovery_window_in_days = 7
    },    
  }

  tags = {
    Owner       = "DevOps team"
    Environment = "dev"
    Terraform   = true
  }
}