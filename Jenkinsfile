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

// ========================================================================== //
//                        J e n k i n s   P i p e l i n e
// ========================================================================== //


// https://jenkins.io/doc/book/pipeline/syntax/


pipeline {

    // run pipeline any agent
    agent any

    // can't do this when running jenkins in docker itself, gets '.../script.sh: docker: not found'
//    agent {
//      docker {
//          image 'ubuntu:18.04'
//          args '-v $HOME/.m2:/root/.m2 -v $HOME/.cache/pip:/root/.cache/pip -v $HOME/.cpanm:/root/.cpanm -v $HOME/.sbt:/root/.sbt -v $HOME/.ivy2:/root/.ivy2 -v $HOME/.gradle:/root/.gradle'
//      }
//  }

    // need to specify at least one env var if enabling
    //environment {
    //    //CC = 'clang',
    //    DEBUG = '1'
    //}

	// XXX: do not allow untrusted Pipeline jobs / users to use trusted Credentials as they can extract these environment variables
	// will be starred *** out in console log but user scripts can still print these
	// this could be moved under a stage to limit the scope of their visibility
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }

    options {
        // put timestamps in console logs
        timestamps()

        // timeout entire pipeline after 4 hours
        timeout(time: 2, unit: 'HOURS')

        //retry entire pipeline 3 times
        //retry(3)
        // enable dthe build status feedback to Jenkins

        gitLabConnection('Gitlab')
        gitlabCommitStatus(name: "Jenkins build $BUILD_DISPLAY_NAME")
    }

    triggers {
        cron('H 10 * * 1-5')
        pollSCM('H/2 * * * *')
    }

    //parameters {
    //    string(name: 'MyVar', defaultValue: 'MyString', description: 'blah')
    //}

    stages {
        stage ('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/harisekhon/devops-bash-tools']]])
            }
        }

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
//                timeout(time: 10, unit: 'MINUTES') {
//                    retry(3) {
////                        sh 'apt update -q'
////                        sh 'apt install -qy make'
////                        sh 'make init'
//                        sh """
//                            setup/ci_bootstrap.sh &&
//                            make init
//                        """
//                    }
//                }
//                timeout(time: 180, unit: 'MINUTES') {
//                    sh 'make ci'
//                }
                // saves artifacts to Jenkins master for basic reporting and archival - not a substitute for Nexus / Artifactory
                // archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            }
        }

        stage('Test') {
            //options {
            //    retry(2)
            //}
            steps {
                echo 'Testing..'
                timeout(time: 60, unit: 'MINUTES') {
                    sh 'make test'
                    // junit '**/target/*.xml'
                }
            }
        }

//        stage('Human gate') {
//            steps {
//                input "Proceed to deployment?"
//            }
//        }

        stage('Deploy') {
            steps {
                echo 'Deploying....'
                // push artifacts and/or deploy to production
                timeout(time: 15, unit: 'MINUTES') {
                    sh 'make deploy'
                }
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

    post {
        always {
            echo 'Always'
            //deleteDir() // clean up workspace

            // collect JUnit reports for Jenkins UI
            //junit 'build/reports/**/*.xml'
            //junit '**/target/*.xml'
            //
            // collect artifacts to Jenkins for analysis
            //archiveArtifacts artifacts: 'build/libs/**/*.jar', fingerprint: true
            //archiveArtifacts 'src/*/*/*.tap'
            //step([$class: "TapPublisher", testResults: 'src/*/*/*.tap', verbose: false])
        }
        success {
            echo 'SUCCESS!'
        }
        failure {
            echo 'FAILURE!'
            //mail to: team@example.com, subject: 'The Pipeline failed :('
        }
        unstable {
            echo 'UNSTABLE!'
        }
        changed {
            echo 'Pipeline state change! (success vs failure)'
        }
    }
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
