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

def call(from_branch, to_branch){
  echo "Running ${env.JOB_NAME} Build ${env.BUILD_ID} on ${env.JENKINS_URL}"
  timeout(time: 1, unit: 'MINUTES') {
    sh script: 'env | sort', label: 'Environment'
  }
  String gitMergeLock = "Git Merge '$from_branch' to '$to_branch'"
  echo "Acquiring Git Merge Lock: $gitMergeLock"
  lock(resource: gitMergeLock, inversePrecedence: true) {
    milestone ordinal: 1, label: "Milestone: Git Merge '$from_branch' to '$to_branch'"
    timeout(time: 5, unit: 'MINUTES') {
      // XXX: define this SSH private key in Jenkins -> Manage Jenkins -> Credentials as SSH username with private key
      sshagent (credentials: ['github-ssh-key']) {
        retry(2) {
          sh """#!/bin/bash
                set -euxo pipefail

                # needed to check in
                git config user.name "Jenkins"
                git config user.email "platform-engineering@MYDOMAIN.CO.UK"  # XXX: change this

                git status

                mkdir -pv ~/.ssh

                # needed for git pull to work
                ssh-keyscan github.com >> ~/.ssh/known_hosts

                git fetch

                git checkout "$to_branch" --force
                git pull --no-edit
                git merge "origin/$from_branch" --no-edit

                git push
            """
        }
      }
    }
  }
}
