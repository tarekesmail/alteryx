#!/bin/sh
export APP_NAME="teleport-agent-${PDP_NAME}"

# sleep to allow Argo time to register that the cluster secret has been deleted
sleep 60

echo $GOOGLE_CREDENTIALS | base64 -d > key.json

gcloud auth login --cred-file='key.json' --quiet
gcloud container clusters get-credentials "$CONTROL_PLANE_NAME" --region "$CONTROL_PLANE_REGION" --project "$CONTROL_PLANE_NAME"

# kube patch teleport app
response=$(kubectl patch applications.argoproj.io "$APP_NAME" -n argocd-bender -p '{"metadata":{"finalizers":null}}' --type=merge)

# don't error the tf apply because this isn't critical to PDP function
if [ "$?" -ne 0 ]; then
  echo "{ \"action\": \"delete\", \"status\" : \"FAILED\", \"response\": \"${response}\" }"
  exit 0
fi

echo "{ \"App\": \"${APP_NAME}\", \"Status\" : \"DELETED\" }"
exit 0