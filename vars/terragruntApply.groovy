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

// $APP and $ENVIRONMENT must be set in pipeline to ensure separate locking

def call(timeoutMinutes=30){
  label 'Terragrunt Apply'
  lock(resource: "Terraform - App: $APP, Environment: $ENVIRONMENT", inversePrecedence: true) {  // use same lock between Terraform / Terragrunt for safety
    // forbids older applys from starting
    milestone(ordinal: 100, label: "Milestone: Terragrunt Apply")

    // XXX: set Terragrunt version in the docker image tag in jenkins-agent-pod.yaml
    container('terragrunt') {
      timeout(time: timeoutMinutes, unit: 'MINUTES') {
        //dir ("components/${COMPONENT}") {
        ansiColor('xterm') {
          // for test environments, add a param to trigger -destroy switch
          sh label: 'Terragrunt Apply',
             script: 'terragrunt apply plan.zip --terragrunt-non-interactive -input=false -auto-approve'
        }
      }
    }
  }
}
