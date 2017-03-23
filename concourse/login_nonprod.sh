#!/bin/bash

ROOT_ADDRESS=${1:-10.59.227.243}
TARGET=${2:-nonprod}

fly -t $TARGET login -c http://${ROOT_ADDRESS}:8080 -u=admin -p=concourse
