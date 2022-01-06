//
//  Author: Hari Sekhon
//  Date: 2022-01-06 18:02:06 +0000 (Thu, 06 Jan 2022)
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

// Requires the following environment variables to be set in pipeline:
//
//  JDBC_URL - full jdbc url to the DB
//  LIQUIBASE_CREDENTIALS - type usernamePassword to implicitly expand to LIQUIBASE_CREDENTIALS_USR/LIQUIBASE_CREDENTIALS_PSW
//  LIQUIBASE_CHANGELOG_FILE - xml file

def call(timeoutMinutes=20){
  label 'Liquibase Status'

  // XXX: set Liquibase version in the docker image tag in jenkins-agent-pod.yaml
  container('liquibase') {
    timeout(time: timeoutMinutes, unit: 'MINUTES') {
      ansiColor('xterm') {
        sh label: 'Liquibase Version',
          script: 'liquibase --version'

        sh label: 'Liquibase Status',
          script: 'liquibase status --url="$JDBC_URL" --changeLogFile="$LIQUIBASE_CHANGELOG_FILE" --username="$LIQUIBASE_CREDENTIALS_USR" --password="$LIQUIBASE_CREDENTIALS_PSW"'
      }
    }
  }
}
