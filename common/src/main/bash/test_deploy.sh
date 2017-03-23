#!/bin/bash

set -ex

source pipeline.sh || echo "No pipeline.sh found"

echo "Running retrieval of group and artifactid to download all dependencies. It might take a while..."
retrieveGroupId
retrieveArtifactId

projectGroupId=$( retrieveGroupId )
projectArtifactId=$( retrieveArtifactId )
currentVersion=$( retrieveCurrentVersion )

# download app, eureka, stubrunner
downloadJar 'true' ${REPO_WITH_JARS} ${projectGroupId} ${projectArtifactId} ${currentVersion} ${REPO_WITH_JARS_INSECURE}
# downloadJar ${REDEPLOY_INFRA} ${REPO_WITH_JARS} ${EUREKA_GROUP_ID} ${EUREKA_ARTIFACT_ID} ${EUREKA_VERSION} ${REPO_WITH_JARS_INSECURE}
# downloadJar ${REDEPLOY_INFRA} ${REPO_WITH_JARS} ${STUBRUNNER_GROUP_ID} ${STUBRUNNER_ARTIFACT_ID} ${STUBRUNNER_VERSION} ${REPO_WITH_JARS_INSECURE}
# Log in to CF to start deployment
logInToCf "${REDOWNLOAD_INFRA}" "${CF_TEST_USERNAME}" "${CF_TEST_PASSWORD}" "${CF_TEST_ORG}" "${CF_TEST_SPACE}" "${CF_TEST_API_URL}"
# setup services
deployServices
# deploy app
deployAndRestartAppWithNameForSmokeTests ${projectArtifactId} "${projectArtifactId}-${currentVersion}"
propagatePropertiesForTests ${projectArtifactId}
