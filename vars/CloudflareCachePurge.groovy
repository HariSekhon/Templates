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
  String cloudflareCachePurgeLock = "Cloudflare Purge Cache - '" + "${env.ENVIRONMENT}".capitalize() + "' Environment"
  echo "Acquiring Cloudflare Cache Purge Lock: $cloudflareCachePurgeLock"
  lock(resource: cloudflareCachePurgeLock, inversePrecedence: true){
    milestone ordinal: 90, label: "Milestone: Cloudflare Purge Cache"
    retry(2){
      timeout(time: 1, unit: 'MINUTES') {
        // script from DevOps Bash tools repo
        // external script needs to exist in the source repo, not the shared library repo
        sh 'cloudflare_purge_cache.sh'
      }
    }
  }
}
