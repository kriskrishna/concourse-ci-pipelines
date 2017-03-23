#!/bin/bash

VERSION=0.0.1.M1-`date +%Y%m%d_%H%M%S`
MESSAGE="[Concourse CI] Bump to Next Version ($VERSION)"

cd out

cp -r ../version/. ./
echo "Bump to ${VERSION}"
echo "${VERSION}" > version

git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_NAME}"
git add version
git commit -m "${MESSAGE}"
