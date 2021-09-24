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

    pipeline {

      agent any

      options {
        disableConcurrentBuilds()
      }

      // backup to catch GitHub -> Jenkins webhook failures
      triggers {
        pollSCM('H/10 * * * *')
      }

      environment {
        SLACK_MESSAGE = "Pipeline <${env.JOB_DISPLAY_URL}|${env.JOB_NAME}> - <${env.RUN_DISPLAY_URL}|Build #${env.BUILD_NUMBER}>"
      }

      stages {

        stage('Git Merge') {
          steps {
            gitMerge("$from_branch", "$to_branch")
          }
        }
      }

      post {
        failure {
          script {
            env.LOG_COMMITTERS = sh(script:"git log --format='@%an' \"${env.GIT_PREVIOUS_SUCCESSFUL_COMMIT}..${env.GIT_COMMIT}\" | grep -Fv -e '[bot]' -e Jenkins | sort -u | tr '\\n' ' '", returnStdout: true, label: 'Get Committers').trim()
          }
          echo "Inferred committers since last successful build via git log to be: ${env.LOG_COMMITTERS}"
          slackSend color: 'danger',
            message: "Git Merge FAILED - ${env.SLACK_MESSAGE} - @here ${env.LOG_COMMITTERS}",
            botUser: true
        }
        fixed {
          slackSend color: 'good',
            message: "Git Merge Fixed - ${env.SLACK_MESSAGE}",
            botUser: true
        }
      }

    }

}
