#!/bin/bash

sudo yum makecache fast

sudo yum install dos2unix -y

echo "Downloading fly;"
sudo curl -k -o "/tmp/fly" "http://10.59.227.243:8080/api/v1/cli?arch=amd64&platform=linux"

echo "Copy fly to /usr/bin"
sudo mv /tmp/fly /usr/bin
sudo chmod 777 /usr/bin/fly