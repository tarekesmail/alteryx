#!/bin/bash

echo '${userdata}' | base64 -d > teleport.tar.gz
mkdir extr
cd extr
mv ../teleport.tar.gz .

tar -xzvf teleport.tar.gz

cd teleport/tprt-agent-bootstrap
/bin/bash install.sh
