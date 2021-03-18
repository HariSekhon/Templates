#!/usr/bin/env groovy
//  vim:ts=2:sts=2:sw=2:et:filetype=groovy:syntax=groovy
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

    // agent setting is required otherwise build won't ever run
    // run pipeline any agent
    agent any
    // can override this on a per stage basis, but leaving this as any will incur some overhead on the Jenkins master in that case, better to switch whole pipeline to a remote agent if you can, unless you want to parallelize the stages among different agents, which might be especially useful for on-demand cloud agents run in Kubernetes

//    agent {
      // run pipeline inside a docker container (requires the jenkins agent has native docker command and docker access - not available by default in jenkins docker images), see:
      //
      //  https://github.com/HariSekhon/Dockerfiles/tree/master/jenkins-agent-docker
      //  https://github.com/HariSekhon/Kubernetes-templates/blob/master/jenkins-agent-cloud-pod.yaml
      //
//      docker {
//          image 'ubuntu:18.04'
//          args '-v $HOME/.m2:/root/.m2 -v $HOME/.cache/pip:/root/.cache/pip -v $HOME/.cpanm:/root/.cpanm -v $HOME/.sbt:/root/.sbt -v $HOME/.ivy2:/root/.ivy2 -v $HOME/.gradle:/root/.gradle'
//      }

      // run pipeline in a k8s pod, can choose different containers in stages further down
//      kubernetes {
//        //label 'mylabel'
//        defaultContainer 'gcloud-sdk'  // default container the build executes in, otherwise uses jnlp by default which doesn't have the right tooling
//        //yamlFile 'jenkins-k8s-pod.yaml'  // use external pod spec file, relative to root of repo, better for yaml validation and sharing between pipelines
//        yaml """\
//          apiVersion: v1
//          kind: Pod
//          metadata:
//            namespace: jenkins
//          #  labels:
//          #    app: gcloud-sdk
//          spec:
//            containers:
//              - name: gcloud-sdk  // do not name this 'jnlp', without that container this'll never come up properly to execute the build
//                image: gcr.io/google.com/cloudsdktool/cloud-sdk:latest
//                tty: true
//              # more containers if you want to run different stages in different containers
//          #     - name: busybox
//          #       image: busybox
//          #       command:
//          #       - cat
//          #       tty: true
//          #      - name: golang
//          #        image: golang:1.10
//          #        command:
//          #          - cat
//          #        tty: true  # required
//          """.stripIndent()
//       }
//    }

    // need to specify at least one env var if enabling
    //environment {
    //    //CC = 'clang',
    //    DEBUG = '1'
    //}

    // Credentials:
    //
    //      https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials
    //
    // XXX: do not allow untrusted Pipeline jobs / users to use trusted Credentials as they can extract these environment variables
    //
    // these will be starred out *** in console log but user scripts can still print these
    // can move this under a stage to limit the scope of their visibility
    environment {
        // create these credentials as Secret Text in Jenkins UI -> Manage Jenkins -> Manage Credentials -> Jenkins -> Global Credentials -> Add Credentials
        AWS_ACCESS_KEY_ID     = credentials('aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        GCP_SERVICEACCOUNT_KEY = credentials('gcp-serviceaccount-key')
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
                // execute in container name defined in the kubernetes {} section near the top
                //container('gcloud-sdk') {

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
                //}
            }
        }

        stage('Build') {
            // start tracking concurrent build order
            // only apply env to this stage
            environment {
                DEBUG = '1'
            }
            // specify agent at stage level to build on different environments
//            agent {
//                label 'linux'
//            }
            steps {
                // forbids older builds from starting
                milestone(1)
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

        // lock multiple stages into 1 concurrent execution using a parent stage
        stage('Parent') {
          options {
            lock('something')
          }
          stages {
            stage('one') {
              ...
            }
            stage('two') {
              ...
            }
          }
        }

        stage('Deploy') {
            //when { branch pattern: '^production$', comparator: 'REGEXP' }
            when { branch pattern: 'production' }

            // prompt to deploy
            input "Deploy?"
            // discard other deploys once this one has been chosen
            // use Lockable Resources plugin to limit deploy concurrency to 1
            // inversePrecedence: true makes Jenkins use the most recent deployment first, which when combined with Milestone, discards older deploys
            lock(resource: 'Deploy', inversePrecedence: true) {
                steps {
                    // forbids older deploys from starting
                    milestone(2)
                    echo 'Deploying....'
                    // push artifacts and/or deploy to production
                    timeout(time: 15, unit: 'MINUTES') {
                        sh 'make deploy'
                    }
                }
            }

        stage('Deploy Canary') {
            // XXX: remember to escape backslashes (double backslash)
            //when { branch pattern: '^staging$', comparator: 'REGEXP' }
            when { branch pattern: 'staging' }
            //when { not { branch pattern: 'production' } }

            // uses a Jenkins credential containing an uploaded .kube/config
            withKubeConfig([credentialsId:kubeconfig, contextName:canary]){
                sh 'kubectl apply -f manifests/'
            }
            // EITHER OR
            // - this autoloads kubeconfig from GKE using GCP serviceaccount credential key
            // - find this in DevOps Bash tools repo - https://github.com/HariSekhon/DevOps-Bash-tools/
            sh 'path/to/gcp_ci_deploy_k8s.sh'
        }

        stage('Deploy Production') {
            // protection for Multibranch Pipelines to not deploy the wrong environment (prod may have side effects eg. customer notifications that you absolutely cannot allow into Staging / Development environments)
            // path glob by default
            when { branch pattern: 'production' }
            // TODO: test this in Prod
            // XXX: remember to escape backslashes (double backslash)
            //when { branch pattern: '^production$', comparator: 'REGEXP' }

            withKubeConfig([credentialsId:kubeconfig, contextName:prod]){
                sh 'kubectl apply -f manifests/'
            }
            // EITHER OR
            // - this autoloads kubeconfig from GKE using GCP serviceaccount credential key
            // - find this in DevOps Bash tools repo - https://github.com/HariSekhon/DevOps-Bash-tools/
            sh 'path/to/gcp_ci_deploy_k8s.sh'
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
            //slackSend channel: '#ops-room',
            //          color: 'good',
            //          message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
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
