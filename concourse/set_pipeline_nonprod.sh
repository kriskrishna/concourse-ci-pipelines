#!/bin/bash -e

function usage() {
  echo "USAGE: ./set_pipeline_nonprod <pipeline_name> <alias> <credentials.yml> <pipeline.yml>"
  exit 0
}
PIPELINE_NAME=$1
if [ -z "${PIPELINE_NAME}" ]; then
  echo "You must provide a name for your pipeline."
  usage
fi
ALIAS=${2:-nonprod}
CREDENTIALS=${3:-credentials.yml}
PIPELINE_CONFIG=${4:-pipeline.yml}

echo y | fly -t "${ALIAS}" sp -p "${PIPELINE_NAME}" -c "${PIPELINE_CONFIG}" -l "${CREDENTIALS}"
