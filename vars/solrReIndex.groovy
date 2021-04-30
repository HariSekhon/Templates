//
//  Author: Hari Sekhon
//  Date: 2021-04-30 15:25:01 +0100 (Fri, 30 Apr 2021)
//
//  vim:ts=2:sts=2:sw=2:et
//
//  https://github.com/HariSekhon/DevOps-Bash-tools
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

def call(){
  echo "Solr Re-Indexing '" + "${env.ENVIRONMENT}".capitalize() + "' from branch '${env.GIT_BRANCH}'"
  String deploymentLock = "Deploy Apps - " + "${env.ENVIRONMENT}".capitalize() + " Environment"
  String indexingLock = "Solr Re-Indexing - " + "${env.ENVIRONMENT}".capitalize() + " Environment"
  echo "Acquiring Deployment Lock: $deploymentLock"
  // prevents running a deployment while reindexing
  lock(resource: deploymentLock, inversePrecedence: true){
    echo "Acquiring Indexing Lock: $indexingLock"
    lock(resource: indexingLock, inversePrecedence: true){
      milestone ordinal: 50, label: "Milestone: Solr Reindexing"
      retry(2){
        timeout(time: 90, unit: 'MINUTES') {
          sh 'path/to/solr-reindex.sh'
        }
      }
    }
  }
}
