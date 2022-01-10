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

// https://github.com/anchore/grype

// Requires DOCKER_IMAGE and DOCKER_TAG to be set in environment{} section of pipeline

def call(timeoutMinutes=10){
  label 'Grype'
  container('grype') {
    timeout(time: timeoutMinuntes, unit: 'MINUTES') {
      ansiColor('xterm') {
          sh "grype '$DOCKER_IMAGE':'$DOCKER_TAG' --scope all-layers"
      }
    }
  }
}
