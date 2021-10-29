//
//  Author: Hari Sekhon
//  Date: 2021-10-08 10:52:41 +0100 (Fri, 08 Oct 2021)
//
//  vim:ts=4:sts=4:sw=4:et
//
//  https://github.com/HariSekhon/Templates
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

// Updates the Kubernetes GitOps repo (which ArgoCD watches) when new builds are created
//
// Requires the following environment variables to be already set in the pipeline environment{} section:
//
//    APP
//    ENVIRONMENT
//    GIT_USERNAME
//    GIT_EMAIL
//    GITOPS_REPO
//    DOCKER_IMAGE
//    GIT_COMMIT - provided automatically by Jenkins
//
// Could be adapted to take these as parameters if multiple GitOps updates were done in a single pipeline, but more likely those should be separate pipelines

def call(timeoutSeconds=120){
  String gitOpsLock = "GitOps Kubernetes Image Update - App: '$APP', Environment: '" + "$ENVIRONMENT".capitalize() + "'"
  echo "Acquiring Lock: $gitOpsLock"
  lock(resource: gitOpsLock, inversePrecedence: true){
    retry(2){
      timeout(time: timeoutSeconds, unit: 'SECONDS'){
        sh """#!/bin/bash
          set -euo pipefail
          git config --global user.name  "$GIT_USERNAME"
          git config --global user.email "$GIT_EMAIL"
          mkdir -pv ~/.ssh
          #ssh-add -l || :

          # convenient but not secure
          #ssh-keyscan github.com >> ~/.ssh/known_hosts
          #ssh-keyscan gitlab.com >> ~/.ssh/known_hosts
          #ssh-keyscan ssh.dev.azure.com >> ~/.ssh/known_hosts
          #ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts
          # or
          #export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
          # or
          #cat >> ~/.ssh/config <<EOF
#Host *
#  LogLevel DEBUG3
#  #CheckHostIP no  # used ssh-keyscan instead
#EOF
          #
          # copy from ssh-keyscan above and then hardcode here for better security:
          #echo "[ssh.github.com]:443 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts
          echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts

          #export GIT_TRACE=1
          #export GIT_TRACE_SETUP=1
          git clone --branch "$ENVIRONMENT" "$GITOPS_REPO" repo
          cd "repo/$APP/$ENVIRONMENT"
          #kustomize edit set image "$GCR_REGISTRY/$GCR_PROJECT/$APP:$GIT_COMMIT"
          kustomize edit set image "$DOCKER_IMAGE:$GIT_COMMIT"
          git add -A
          if ! git diff-index --quiet HEAD; then
            git commit -m "updated WWW $ENVIRONMENT app image version to build $GIT_COMMIT"
          fi
          git push
        """
      }
    }
  }
}
