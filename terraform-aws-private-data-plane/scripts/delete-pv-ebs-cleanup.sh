#!/bin/sh

## This is a cleanup script to delete all EBS created for PV

# Get the list of all not attached pv ebs id
EBS_LIST=$(aws ec2 describe-volumes --region "$REGION" --filters Name=status,Values=available --filters Name=tag:Name,Values=aac-*-eks-dynamic-pvc-* --query "Volumes[*].VolumeId" --output text)
# Loop through each EBS
for EBS in $EBS_LIST; do
  echo "Deleting volume $EBS"
  aws ec2 delete-volume --volume-id $EBS --region $REGION

  if [ $? -eq 0 ]; then
    echo "Volume $EBS deleted"
  else
    echo "Failed to delete $EBS volume"
  fi

done
