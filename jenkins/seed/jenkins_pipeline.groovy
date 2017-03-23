import javaposse.jobdsl.dsl.DslFactory

DslFactory factory = this

String repos = 'https://github.com/pivotalservices/sample-spring-cloud-svc,https://github.com/pivotalservices/sample-spring-cloud-svc'

factory.job('jenkins-pipeline-seed') {
    environmentVariables {
        overrideBuildParameters()
    }
    scm {
        git {
            remote {
                github('dte_replatforming/ci-pipelines')
            }
            branch('master')
        }
    }
    wrappers {
        parameters {
            stringParam('REPOS', repos,
                    "Provide a comma separated list of repos. If you want the project name to be different then repo name, " +
                            "first provide the name and separate the url with \$ sign")
            stringParam('GIT_CREDENTIAL_ID', 'git', 'ID of the credentials used to push tags to git repo')
            stringParam('JDK_VERSION', 'jdk8', 'ID of Git installation')
            stringParam('CF_TEST_CREDENTIAL_ID', 'p@ssw0rd', 'ID of the CF credentials for test environment')
            stringParam('CF_STAGE_CREDENTIAL_ID', 'p@ssw0rd', 'ID of the CF credentials for stage environment')
            stringParam('CF_PROD_CREDENTIAL_ID', 'p@ssw0rd', 'ID of the CF credentials for prod environment')
            stringParam('CF_TEST_API_URL', 'api.system.pcfpre-phx.cloud.boeing.com', 'URL to CF Api for test env')
            stringParam('CF_STAGE_API_URL', 'api.system.pcfpre-phx.cloud.boeing.com', 'URL to CF Api for stage env')
            stringParam('CF_PROD_API_URL', 'api.system.pcfpre-phx.cloud.boeing.com', 'URL to CF Api for prod env')
            stringParam('CF_TEST_ORG', 'GeoDoc', 'Name of the CF organization for test env')
            stringParam('CF_TEST_SPACE', 'test', 'Name of the CF space for test env')
            stringParam('CF_STAGE_ORG', 'GeoDoc', 'Name of the CF organization for stage env')
            stringParam('CF_STAGE_SPACE', 'stage', 'Name of the CF space for stage env')
            stringParam('CF_PROD_ORG', 'GeoDoc', 'Name of the CF organization for prod env')
            stringParam('CF_PROD_SPACE', 'prod', 'Name of the CF space for prod env')
            stringParam('M2_SETTINGS_REPO_ID', 'artifactory-local', "Name of the server ID in Maven's settings.xml")
            stringParam('M2_SETTINGS_REPO_USERNAME', 'admin', 'Your BEMSID')
            stringParam('M2_SETTINGS_REPO_PASSWORD', 'password', 'Your Artifactory API key')
            stringParam('REPO_WITH_JARS', 'https://sres.web.boeing.com/artifactory/Maven-Snapshots', "Address to hosted JARs")
            stringParam('GIT_EMAIL', 'reese.l.schultz@boeing.com', "Email used to tag the repo")
            stringParam('GIT_NAME', 'Reese L Schultz', "Name used to tag the repo")
            stringParam('CF_HOSTNAME_UUID', 'pcfpre', "Additional suffix for the route. In a shared environment the default routes can be already taken")
            booleanParam('AUTO_DEPLOY_TO_STAGE', true, 'Should deployment to stage be automatic')
            booleanParam('AUTO_DEPLOY_TO_PROD', false, 'Should deployment to prod be automatic')
            booleanParam('ROLLBACK_STEP_REQUIRED', false, 'Should rollback step be present')
        }
    }
    steps {
        gradle("clean build -PmavenUser=$M2_SETTINGS_REPO_USERNAME -PmavenPassword=$M2_SETTINGS_REPO_PASSWORD")
        dsl {
            external('jenkins/jobs/jenkins_pipeline_sample*.groovy')
            removeAction('DISABLE')
            removeViewAction('DELETE')
            ignoreExisting(false)
            lookupStrategy('SEED_JOB')
            additionalClasspath([
                'jenkins/src/main/groovy', 'jenkins/src/main/resources'
            ].join("\n"))
        }
    }
}
