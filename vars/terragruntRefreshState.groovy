//
//  Author: Hari Sekhon
//  Date: 2022-01-07 18:48:47 +0000 (Fri, 07 Jan 2022)
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

// For large estates to run a separate refresh-only job periodically to keep the state file up to date
//
// $APP and $ENVIRONMENT must be set in pipeline to ensure separate locking

def call(timeoutMinutes=59){
  label 'Terragrunt Refresh State'
  lock(resource: "Terraform - App: $APP, Environment: $ENVIRONMENT", inversePrecedence: true) {
    // forbids older runs from starting
    milestone(ordinal: 100, label: "Milestone: Terragrunt Refresh State")

    // XXX: set Terragrunt version in the docker image tag in jenkins-agent-pod.yaml
    container('terragrunt') {
      timeout(time: timeoutMinutes, unit: 'MINUTES') {
        //dir ("components/${COMPONENT}") {
        ansiColor('xterm') {
          // for test environments, add a param to trigger -destroy switch
          sh label: 'Terragrunt Refresh State',
             script: 'terragrunt apply -refresh-only --terragrunt-non-interactive -input=false'
        }
      }
    }
  }
}
