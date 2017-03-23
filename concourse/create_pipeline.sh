#!/bin/bash -e

pipeline_dir=$(dirname $0)

if [! -f "credentials.yml" ]; then
  cp credentials-sample.yml credentials.yml
fi

trap 'rm generated_pipeline.yml' EXIT
echo "---" > $pipeline_dir/generated_pipeline.yml
cat resources.yml >> generated_pipeline.yml
echo "jobs:" >> $pipeline_dir/generated_pipeline.yml

echo "Hello, "$USER".  This script will create a Concourse pipeline for your microservice."
echo -n "Enter your project name and press [ENTER]: "
read projectName
echo -n "Does your microservice call other microservices that need to be stubbed? [Y/N]: "
read rollback

passed="test-smoke"
cat jobs/generate-version.yml >> generated_pipeline.yml
cat jobs/build-and-upload.yml >> generated_pipeline.yml
cat jobs/test-deploy.yml >> generated_pipeline.yml
cat jobs/test-smoke.yml >> generated_pipeline.yml
shopt -s nocasematch
if [[ $rollback = "y" ]]; then
  cat jobs/test-rollback-deploy.yml >> generated_pipeline.yml
  cat jobs/test-rollback-smoke.yml >> generated_pipeline.yml
  passed="test-rollback-smoke"
fi
ruby -rerb -e "@passed='${passed}'; puts ERB.new(File.read('jobs/stage-deploy.yml.erb')).result(binding)" >> generated_pipeline.yml
cat jobs/stage-e2e.yml >> generated_pipeline.yml
cat jobs/prod-deploy.yml >> generated_pipeline.yml
cat jobs/prod-complete.yml >> generated_pipeline.yml

. ${pipeline_dir}/login.sh 10.59.227.243 nonprod
. ${pipeline_dir}/set_pipeline.sh ${projectName} nonprod credentials.yml generated_pipeline.yml

