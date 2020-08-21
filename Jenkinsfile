#!/usr/bin/env groovy
//  vim:ts=4:sts=4:sw=4:et:filetype=groovy:syntax=groovy
//
//  Author: Hari Sekhon
//  Date: [% DATE # 2017-06-28 12:39:02 +0200 (Wed, 28 Jun 2017) ]
//
//  [% URL %]
//
//  [% LICENSE %]
//
//  [% MESSAGE %]
//
//  [% LINKEDIN %]
//

pipeline {
    agent any

    environment {
        //CC = 'clang',
        DEBUG = '1'
    }

    options {
        // put timestamps in console logs
        timestamp()

        // enable dthe build status feedback to Jenkins
        gitLabConnection('Gitlab')
        gitlabCommitStatus(name: "Jenkins build $BUILD_DISPLAY_NAME")
    }

    //parameters {
    //    string(name: 'MyVar', defaultValue: 'MyString', description: 'blah')
    //}

    stages {
        stage('Setup') {
            steps {
                // rewrite build name to include commit id
                script {
                    currentBuild.displayName = "$BUILD_DISPLAY_NAME (${GIT_COMMIT.take(8)})"
                }

                // save workspace path to use in tests
                script {
                    workspace = "$env.WORKSPACE"
                }

                // run some shell commands to set things up
                sh '''
                    for x in /etc/mybuild.d/*.sh; do
                        if [ -r "$x" ]; then
                            source $x;
                        fi;
                    done;
                '''
            }
        }

        stage('Build') {
            // only apply env to this stage
            environment {
                DEBUG = '1'
            }
            // specify agent at stage level to build on different environments
//            agent {
//                label 'linux'
//            }
            steps {
                //echo "${params.MyVar}"
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
                echo 'Building..'
                sh 'make'
                // saves artifacts to Jenkins master for basic reporting and archival - not a substitute for Nexus / Artifactory
                // archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            }
        }

        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'make test'
                // junit '**/target/*.xml'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying....'
                // push artifacts and/or deploy to production
            }
        }
    }

    // see https://jenkins.io/blog/2017/09/25/declarative-1/
    stage('Parallel stuff') {
        parallel {
            stage('stage 1') {
                steps {
                    ...
                }
            }
            stage('stage B') {
                steps {
                    ...
                }
            }
        }
    }

//    post {
//        // always, unstable, success, failure or changed
//        always {
//            junit '**/target/*.xml'
//            step([$class: "TapPublisher", testResults: 'src/*/*/*.tap', verbose: false])
//            archiveArtifacts 'src/*/*/*.tap'
//        }
//        failure {
//            mail to: team@example.com, subject: 'The Pipeline failed :('
//        }
//    }
}

// https://github.com/jenkinsci/pipeline-examples/tree/master/jenkinsfile-examples/sonarqube:
//
// - Manage Jenkins > Configure System and set up SonarQube Servers
// - Create a new Pipeline job and set the url for your SCM, which contains the Jenkinsfile
//
//node {
//    stage 'Checkout'
//
//    checkout scm
//
//    stage 'Gradle Static Analysis'
//    withSonarQubeEnv {
//        sh "./gradlew clean sonarqube"
//    }
//}
