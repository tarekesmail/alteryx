#!/bin/bash

echo '#!/bin/bash' > exportenvs.sh
cat setenv.sh | while read line; do
  echo "export $line" >> exportenvs.sh
done

source exportenvs.sh

env

cp -v teleport.cer /root/

cp -rv golang /root/

cd /root

mkdir installgo

cd installgo

wget https://go.dev/dl/go1.20.linux-amd64.tar.gz 

tar -xzf go1.20.linux-amd64.tar.gz 

mv go /usr/local/

chmod a+rx /usr/local/go/bin/go

cd /root/golang

mkdir /root/gocache

export GOCACHE=/root/gocache

export HOME=/root

export GOPATH=/usr/local/go

export PATH=$PATH:$GOPATH/bin

go get

go build

cp -v main /home/ec2-user/

chmod a+rx main

env > /home/ec2-user/envs.txt

export AWS_REGION=$TELEPORT_AWS_REGION

sleep 120

source /etc/os-release

sudo dnf config-manager --add-repo "$(rpm --eval "https://yum.releases.teleport.dev/$ID/$VERSION_ID/Teleport/%{_arch}/stable/v14/teleport.repo")"

sudo dnf install teleport jq -y

./main > /etc/teleport.yaml

systemctl restart teleport
