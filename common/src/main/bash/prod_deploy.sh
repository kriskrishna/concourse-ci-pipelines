#!/bin/bash

set -e

source pipeline.sh || echo "No pipeline.sh found"

projectGroupId=$( retrieveGroupId )
projectArtifactId=$( retrieveArtifactId )
currentVersion=$( retrieveCurrentVersion )

# download app
downloadJar 'true' ${REPO_WITH_JARS} ${projectGroupId} ${projectArtifactId} ${currentVersion} ${REPO_WITH_JARS_INSECURE}
# Log in to CF to start deployment
logInToCf "${REDOWNLOAD_INFRA}" "${CF_PROD_USERNAME}" "${CF_PROD_PASSWORD}" "${CF_PROD_ORG}" "${CF_PROD_SPACE}" "${CF_PROD_API_URL}"

# deploying rabbitmq
# TODO: most likely rabbitmq and eureka would be there on production; this remains for demo purposes
# deployRabbitMqToCf
deployServices
# downloadJar ${REDEPLOY_INFRA} ${REPO_WITH_JARS} ${EUREKA_GROUP_ID} ${EUREKA_ARTIFACT_ID} ${EUREKA_VERSION} ${REPO_WITH_JARS_INSECURE}
# deployEureka ${REDEPLOY_INFRA} "${EUREKA_ARTIFACT_ID}-${EUREKA_VERSION}" "${EUREKA_ARTIFACT_ID}" "prod"

# deploy app
renameTheOldApplicationIfPresent "${projectArtifactId}"
deployAndRestartAppWithName "${projectArtifactId}" "${projectArtifactId}-${currentVersion}" "prod"
