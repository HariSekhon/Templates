//
//  Author: Hari Sekhon
//  Date: 2021-09-01 12:50:03 +0100 (Wed, 01 Sep 2021)
//
//  vim:ts=4:sts=4:sw=4:et
//
//  https://github.com/HariSekhon/templates
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

// Required Environment Variables to be set in environment{} section of Jenkinsfile, see top level Jenkinsfile template
//
//    CLOUDSDK_CORE_PROJECT
//    GCP_SERVICEACCOUNT_KEY
//    GCR_REGISTRY
//    DOCKER_IMAGE
//    GIT_COMMIT - provided automatically by Jenkins

def call(timeout_seconds=3600){
  echo "Building from branch '${env.GIT_BRANCH}' for '" + "${env.ENVIRONMENT}".capitalize() + "' Environment"
  milestone ordinal: 10, label: "Milestone: Build"
  echo "Running Job '${env.JOB_NAME}' Build ${env.BUILD_ID} on ${env.JENKINS_URL}"
  retry(2){
    timeout(time: $timeout_seconds, unit: 'SECONDS') {
      echo 'Running GCP CloudBuild'
      sh """#!/bin/bash
        set -euxo pipefail
        echo "\$GCP_SERVICEACCOUNT_KEY" | base64 --decode > credentials.json
        gcloud auth activate-service-account --key-file=credentials.json
        rm -f credentials.json
        if [ -z "$(gcloud container images list-tags "\$DOCKER_IMAGE" --filter="tags:\$GIT_COMMIT" --format=text)" ]; then
          gcloud builds submit --project="\$CLOUDSDK_CORE_PROJECT" --substitutions _REGISTRY="\$GCR_REGISTRY",_IMAGE_VERSION="\$GIT_COMMIT" --timeout=$timeout_seconds
        fi
      """
    }
  }
}
