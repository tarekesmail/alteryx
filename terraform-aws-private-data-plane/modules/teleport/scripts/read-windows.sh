#!/bin/bash

curl -o teleport.cer https://${TELEPORT_CLUSTER}:443/webapi/auth/export?type=windows
certcontent=$(cat teleport.cer | base64)
echo "{\"tprt_cert\": \"$certcontent\"}"
