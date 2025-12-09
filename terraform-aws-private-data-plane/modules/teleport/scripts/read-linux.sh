#!/bin/bash

#curl -o teleport.cer https://teleport.bender.rocks:443/webapi/auth/export?type=windows
cd $PATHROOT
echo '#!/bin/bash' > teleport/setenv.sh
env | grep TELEPORT >> teleport/tprt-agent-bootstrap/setenv.sh
tar -cipz teleport -f teleport.tar.gz
zipcontent=$(cat teleport.tar.gz | base64)
echo "{\"zipcontent\": \"$zipcontent\"}"
