#!/bin/bash

function docker-remove-images() {
  if [ -z "$1" ]; then
    docker rmi $(docker images -q)
  else
    DOCKER_IMAGES=""
    for IMAGE_ID in $@; do DOCKER_IMAGES="$DOCKER_IMAGES\|$IMAGE_ID"; done
    # Find the image IDs for the supplied tags
    ID_ARRAY=($(docker images | grep "${DOCKER_IMAGES:2}" | awk {'print $3'}))
    # Strip out duplicate IDs before attempting to remove the image(s)
    docker rmi $(echo ${ID_ARRAY[@]} | tr ' ' '\n' | sort -u | tr '\n' ' ')
 fi
}

docker rm $(docker ps -a -q)  # Delete all Docker containers
docker-remove-images  # Delete images for supplied IDs or all if no IDs are passed as arguments
docker images -q -f dangling=true |xargs docker rmi  # Delete all untagged Docker images
docker images  # List Docker images
