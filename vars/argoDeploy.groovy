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

// Requires ARGOCD_SERVER and ARGOCD_AUTH_TOKEN environment variables to be set, see top level Jenkinsfile

def call(app, timeoutSeconds=600){
  milestone ordinal: 30, label: "Milestone: Argo Deploy"
  echo "Deploying app '$app' via ArgoCD"
  String deploymentLock = "Deploy ArgoCD app '$app' - " + "${env.ENVIRONMENT}".capitalize() + " Environment"
  lock(resource: deploymentLock, inversePrecedence: true){
    label 'ArgoCD Deploy'
    container('argocd') {
      timeout(time: timeoutSeconds, unit: 'SECONDS') {
        sh """#!/bin/bash
          set -euo pipefail
          argocd app sync "$app" --grpc-web --force
          argocd app wait "$app" --grpc-web --timeout "$timeoutSeconds"
        """
      }
    }
  }
}
