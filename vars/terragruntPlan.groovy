//
//  Author: Hari Sekhon
//  Date: 2022-01-06 17:35:16 +0000 (Thu, 06 Jan 2022)
//
//  vim:ts=2:sts=2:sw=2:et
//
//  https://github.com/HariSekhon/templates
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

def call(timeoutMinutes=10){
  label 'Terraform Plan'
  // forbids older plans from starting
  milestone(ordinal: 50, label: "Milestone: Terragrunt Plan")  // protects duplication by reusing the same milestone between Terraform / Terragrunt in case you leave both in

  // XXX: set Terragrunt version in the docker image tag in jenkins-agent-pod.yaml
  container('terragrunt') {
    steps {
      //dir ("components/${COMPONENT}") {
      ansiColor('xterm') {
        // alpine/terragrunt docker image doesn't have bash
        //sh '''#/usr/bin/env bash -euxo pipefail
        //sh '''#/bin/sh -eux
        sh label: 'Workspace List',
           script: 'terragrunt workspace list || :'  // # 'workspaces not supported' if using Terraform Cloud as a backend
        sh label: 'Terragrunt Plan',
           script: 'terragrunt plan --terragrunt-non-interactive -out=plan.zip -input=false'  // # -var-file=base.tfvars -var-file="$ENV.tfvars"
      }
    }
  }
}
