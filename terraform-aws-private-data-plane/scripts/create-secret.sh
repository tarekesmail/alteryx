#!/bin/sh

MAX_RETRIES=90
WAIT_SECONDS=30
CLEANUP_OAUTH_SECRET="job-runner-sa-oauth-token"

#create a new version secret with valid UUID
aws secretsmanager put-secret-value --secret-id "$KEY_NAME" --region "$REGION" --secret-string "$(aws secretsmanager get-secret-value --secret-id "$KEY_NAME" --region "$REGION" --query SecretString --output text)"

check_secret_value() {
  aws secretsmanager get-secret-value --secret-id "$KEY_NAME" --region "$REGION" --query 'SecretString' --output text 2>/dev/null
  # aws secretsmanager get-secret-value --secret-id "$KEY_NAME" --region "$REGION" --query 'SecretBinary' --output text 2>/dev/null | base64 --decode
}

cleanup_oldsecrets() {
  echo "Checking if secret ${CLEANUP_OAUTH_SECRET} exists in region ${REGION}..!!"
  secret_info=$(aws secretsmanager describe-secret --secret-id "${CLEANUP_OAUTH_SECRET}" --region "${REGION}" 2>/dev/null)
  if [ -n "$secret_info" ]; then
    echo "Secret ${CLEANUP_OAUTH_SECRET} found. Deleting the secret..!!"
    aws secretsmanager delete-secret --secret-id "${CLEANUP_OAUTH_SECRET}" --force-delete-without-recovery --region "${REGION}"
  else
    echo "Secret ${CLEANUP_OAUTH_SECRET} not found."
  fi
}

for i in $(seq 1 ${MAX_RETRIES}); do
  echo "checking if ${KEY_NAME} secret found in AWS secrets manager..!!"
  secret_value=$(check_secret_value)
  # if [[ $secret_value != "{}" && -n "$secret_value" ]]; then
  if [ "$secret_value" != "{}" ] && [ -n "$secret_value" ]; then
    echo "Secret ${KEY_NAME} found!"
    # Perform the cleanup of old secrets here
    cleanup_oldsecrets
    exit 0
  else
    echo "secret ${KEY_NAME} not found, waiting ${WAIT_SECONDS} ..!!"
    sleep ${WAIT_SECONDS}
  fi
done

if [ -z "$secret_value" ]; then
  echo "Timed out after ${MAX_RETRIES} attempts waiting for secret ${KEY_NAME}"
fi
exit 1