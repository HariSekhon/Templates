//
//  Author: Hari Sekhon
//  Date: 2021-04-30 15:25:01 +0100 (Fri, 30 Apr 2021)
//
//  vim:ts=2:sts=2:sw=2:et
//
//  https://github.com/HariSekhon/Templates
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

def call(){
  echo "Deploying '" + "${env.ENVIRONMENT}".capitalize() + "' from branch '${env.GIT_BRANCH}'"
  String deploymentLock = "Deploy K8s Apps - " + "${env.ENVIRONMENT}".capitalize() + " Environment"
  echo "Acquiring Deployment Lock: $deploymentLock"
  lock(resource: deploymentLock, inversePrecedence: true){
    milestone ordinal: 30, label: "Milestone: Deploy"
    retry(2){
      timeout(time: 20, unit: 'MINUTES') {
        // script from DevOps Bash tools repo
        // external script needs to exist in the source repo, not the shared library repo
        sh 'gcp_ci_k8s_deploy.sh'
      }
    }
  }
}
