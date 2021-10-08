//
//  Author: Hari Sekhon
//  Date: 2021-09-01 14:07:59 +0100 (Wed, 01 Sep 2021)
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
//    APP
//    ENVIRONMENT
//    ARGOCD_SERVER
//    ARGOCD_AUTH_TOKEN
//

def call(timeoutSeconds=600){
  milestone ordinal: 30, label: "Milestone: Argo Deploy"
  echo "Deploying app '$APP' via ArgoCD"
  String deploymentLock = "Deploy ArgoCD app '$APP' - " + "$ENVIRONMENT".capitalize() + " Environment"
  lock(resource: deploymentLock, inversePrecedence: true){
    label 'ArgoCD Deploy'
    container('argocd') {
      timeout(time: timeoutSeconds, unit: 'SECONDS') {
        sh """#!/bin/bash
          set -euo pipefail
          argocd app sync "$APP" --grpc-web --force
          argocd app wait "$APP" --grpc-web --timeout "$timeoutSeconds"
        """
      }
    }
  }
}
