#!/bin/sh


aws eks describe-cluster --name $CLUSTER --region $REGION > cluster.json
export CA=$(cat cluster.json | jq -r '.cluster.certificateAuthority.data')
export HOST=$(cat cluster.json | jq -r '.cluster.endpoint')

echo "{ \"HOST\": \"${HOST}\", \"CA\": \"${CA}\" }"