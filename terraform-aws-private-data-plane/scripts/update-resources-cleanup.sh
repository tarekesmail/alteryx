#!/bin/sh


# Output a dummy JSON object for Terraform to prevent change everytime on TF applies
echo "{\"status\": \"no-op\", \"message\": \"This is a cleanup script, no resources created\"}"