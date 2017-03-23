#!/bin/bash

docker stop $(docker ps -a -q) # Stop all running containers

docker-compose stop