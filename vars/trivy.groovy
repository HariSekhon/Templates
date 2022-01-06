//
//  Author: Hari Sekhon
//  Date: 2022-01-06 17:19:11 +0000 (Thu, 06 Jan 2022)
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

// Requires DOCKER_IMAGE and DOCKER_TAG to be set in environment{} section of pipeline

def call(timeoutMinutes=10){
  label 'Trivy'
  container('trivy') {
    timeout(time: timeoutMinuntes, unit: 'MINUTES') {
      ansiColor('xterm') {
          sh "trivy --no-progress --exit-code 1 --severity HIGH,CRITICAL '$DOCKER_IMAGE':'$DOCKER_TAG'"
          // informational to see all issues
          sh "trivy --no-progress '$DOCKER_IMAGE':'$DOCKER_TAG'"
      }
    }
  }
}
