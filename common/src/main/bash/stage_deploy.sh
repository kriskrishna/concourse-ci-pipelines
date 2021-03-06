#!/bin/bash

set -e

source pipeline.sh || echo "No pipeline.sh found"

echo "Retrieving group and artifact id - it can take a while..."
projectGroupId=$( retrieveGroupId )
projectArtifactId=$( retrieveArtifactId )
currentVersion=$( retrieveCurrentVersion )

# download app, eureka
downloadJar 'true' ${REPO_WITH_JARS} ${projectGroupId} ${projectArtifactId} ${currentVersion} ${REPO_WITH_JARS_INSECURE}
# downloadJar ${REDEPLOY_INFRA} ${REPO_WITH_JARS} ${EUREKA_GROUP_ID} ${EUREKA_ARTIFACT_ID} ${EUREKA_VERSION} ${REPO_WITH_JARS_INSECURE}
# Log in to CF to start deployment
logInToCf "${REDOWNLOAD_INFRA}" "${CF_STAGE_USERNAME}" "${CF_STAGE_PASSWORD}" "${CF_STAGE_ORG}" "${CF_STAGE_SPACE}" "${CF_STAGE_API_URL}"
# setup infra
# deployRabbitMqToCf
deployServices
# deployEureka ${REDEPLOY_INFRA} "${EUREKA_ARTIFACT_ID}-${EUREKA_VERSION}" "${EUREKA_ARTIFACT_ID}" "stage"
# deploy app
deployAndRestartAppWithName ${projectArtifactId} "${projectArtifactId}-${currentVersion}" "stage"
propagatePropertiesForTests ${projectArtifactId}
