#!/bin/sh

## This is a cleanup script to delete dangling TCP load balancers that were created from the Hermes repository via the NGINX ingress chart. Since the cluster is being deleted, all resources outside of EKS created via Argo are not gracefully deleted. This script is intended to clean up those dangling resources.

TAG_KEY="kubernetes.io/cluster/$RESOURCE_NAME-eks"

# Get the list of load balancers ARNs
LOAD_BALANCERS=$(aws elbv2 describe-load-balancers --region "$REGION" --query "LoadBalancers[?Type=='network'].LoadBalancerArn" --output text)

# Loop through each load balancer ARN
for LB_ARN in $LOAD_BALANCERS; do
  # Check the tags for the load balancer
  TAGGED_LB_ARN=$(aws elbv2 describe-tags --region "$REGION" --resource-arns "$LB_ARN" --query "TagDescriptions[?Tags[?Key=='$TAG_KEY']].ResourceArn" --output text)

  if [ -n "$TAGGED_LB_ARN" ]; then
    echo "Found Load Balancer: $TAGGED_LB_ARN"
    
    # Delete the load balancer
    aws elbv2 delete-load-balancer --region "$REGION" --load-balancer-arn "$TAGGED_LB_ARN"
    
    if [ $? -eq 0 ]; then
      echo "Load Balancer deleted successfully."
    else
      echo "Failed to delete Load Balancer."
    fi
  else
    echo "No matching Load Balancer found for ARN: $LB_ARN"
  fi
done
