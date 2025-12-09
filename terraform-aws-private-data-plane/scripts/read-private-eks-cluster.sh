#!/bin/sh

## This secret will need to be created manually via AWS console.
## When the secret "aac_eks_api_access" is set to private, private EKS clusters are deployed

check_secret_value() {
  aws secretsmanager get-secret-value --secret-id "aac_eks_api_access" --region "$REGION" --query 'SecretString' --output text 2>/dev/null
}
secret_value=$(check_secret_value)
if [ "$secret_value" != "{}" ] && [ -n "$secret_value" ]; then
    echo "{ \"EKS_API_ACCESS\": \"${secret_value}\"}"
    exit 0
else
    echo "{ \"EKS_API_ACCESS\": \"public\"}"
    exit 0
fi
