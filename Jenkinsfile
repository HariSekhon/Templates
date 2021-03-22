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

  // ========================================================================== //
  //                        S h a r e d   L i b r a r i e s
  // ========================================================================== //


pipeline {

  // ========================================================================== //
  //                                  A g e n t s
  // ========================================================================== //

  // agent setting is required otherwise build won't ever run
  // run pipeline any agent
  agent any
  // can override this on a per stage basis, but leaving this as "any" will incur some overhead on the Jenkins master in that case, better to switch whole pipeline to a remote agent if you can, unless you want to parallelize the stages among different agents, which might be especially useful for on-demand cloud agents run in Kubernetes
  // putting agents{} sections in stage will also have options applied to the agent eg. timeout includes agent provisioning time

  // more fancy agents - Docker or Kubernetes
//  agent {
    //
    // =========================================
    //                Docker
    //
    //    https://www.jenkins.io/doc/book/pipeline/docker/
    //
    // run pipeline inside a docker container (requires the jenkins agent has native docker command and docker access - not available by default in jenkins docker images), see:
    //
    //  https://github.com/HariSekhon/Dockerfiles/tree/master/jenkins-agent-docker
    //  https://github.com/HariSekhon/Kubernetes-templates/blob/master/jenkins-agent.cloud-pod-DooD.yaml
    //
    // put an agent { docker {...} } section in each stage to use different images with different available tools
//    docker {
//      image 'ubuntu:18.04'
//      args '-v $HOME/.m2:/root/.m2 -v $HOME/.sbt:/root/.sbt -v $HOME/.ivy2:/root/.ivy2 -v $HOME/.gradle:/root/.gradle -v $HOME:/.groovy:/root/.groovy -v $HOME/.cache/pip:/root/.cache/pip -v $HOME/.cpan:/root/.cpan -v $HOME/.cpanm:/root/.cpanm -v $HOME/.gem:/root/.gem'
//    }

    // =========================================
    //                Kubernetes
    //
    //    https://plugins.jenkins.io/kubernetes/
    //
    // run pipeline in a k8s pod, can choose different containers in stages further down
//    kubernetes {
//    //label 'mylabel'
//    defaultContainer 'gcloud-sdk'  // default container the build executes in, otherwise uses jnlp by default which doesn't have the right tooling
//    // use external yaml rather than inline pod spec - better for yaml validation and sharing between pipelines
//    // https://github.com/HariSekhon/Kubernetes-templates/blob/master/jenkins-agent-pod.yaml
//    yamlFile 'jenkins-agent-pod.yaml'  // relative to root of repo
//    //yaml """\
//    //  apiVersion: v1
//    //  kind: Pod
//    //  metadata:
//    //  namespace: jenkins
//    //  #  labels:
//    //  #  app: gcloud-sdk
//    //  spec:
//    //    containers:
//    //      - name: gcloud-sdk  # do not name this 'jnlp', without that container this'll never come up properly to execute the build
//    //        image: gcr.io/google.com/cloudsdktool/cloud-sdk:latest
//    //        tty: true
//    //      # more containers if you want to run different stages in different containers
//    //    #  - name: busybox
//    //    #    image: busybox
//    //    #    command:
//    //    #      - cat
//    //    #    tty: true
//    //    #  - name: golang
//    //    #    image: golang:1.10
//    //    #    command:
//    //    #      - cat
//    //    #    tty: true
//    //    """.stripIndent()
//     }
//  }

  // ========================================================================== //
  //                                 O p t i o n s
  // ========================================================================== //

  options {
    // only allow 1 of this pipeline to run at a time - usually better to just lock some stages eg. see Deploy stage further down
    //disableConcurrentBuilds()

    // put timestamps in console logs
    timestamps()

    // timeout entire pipeline after 2 hours
    // XXX: if using Human Gate input in prod pipeline, if you don't confirm the deployment within under 2 hours this build will be cancelled to avoid hogging executors
    timeout(time: 2, unit: 'HOURS')

    //retry entire pipeline 3 times
    //retry(3)

    // https://www.jenkins.io/doc/book/pipeline/syntax/#parallel
    parallelsAlwaysFailFast()

    // only keep last 100 pipeline logs and artifacts
    buildDiscarder(logRotator(numToKeepStr: '100')) }

    // https://www.jenkins.io/doc/pipeline/steps/gitlab-plugin/
    // enable build status feedback to GitLab
    //gitLabConnection('Gitlab')
    //gitlabCommitStatus(name: "Jenkins build $BUILD_DISPLAY_NAME")
  }

  // https://www.jenkins.io/doc/book/pipeline/syntax/#cron-syntax
  triggers {
    // replace 0 with H (hash) to randomize starts to spread load and avoid spikes
    // the time is consistent for each job though as it's based on the hash of the job name
    pollSCM('H/2 * * * *')  // run every 2 mins, at a consistent offset time within that 2 min interval
    cron('H 10 * * 1-5')    // run at 10:XX:XX am every weekday morning, ie. some job fixed time between 10-11am
    cron('@hourly') // same as cron('H * * * *')
    cron('@daily')  // same as cron('H H * * *')
  }

  // need to specify at least one env var if enabling
  //environment {
  //  //CC = 'clang',
  //  DEBUG = '1'
  //}

  //parameters {
  //  string(name: 'MyVar', defaultValue: 'MyString', description: 'blah')
  //}

  // ========================================================================== //
  //                             C r e d e n t i a l s
  // ========================================================================== //

  //    https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials
  //
  // XXX: do not allow untrusted Pipeline jobs / users to use trusted Credentials as they can extract these environment variables
  //
  // these will be starred out *** in console log but user scripts can still print these
  // can move this under a stage to limit the scope of their visibility
  environment {
    // create these credentials as Secret Text in Jenkins UI -> Manage Jenkins -> Manage Credentials -> Jenkins -> Global Credentials -> Add Credentials
    AWS_ACCESS_KEY_ID      = credentials('aws-secret-key-id')
    AWS_SECRET_ACCESS_KEY  = credentials('aws-secret-access-key')
    GCP_SERVICEACCOUNT_KEY = credentials('gcp-serviceaccount-key')
  }

  // ========================================================================== //
  //                                  S t a g e s
  // ========================================================================== //

  // https://www.jenkins.io/doc/pipeline/steps/
  //
  // https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/

  stages {

    // not needed in a multibranch pipeline build which does this automatically
    stage ('Checkout') {
      steps {
        milestone(ordinal: 10, label: "Milestone: Checkout")
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/harisekhon/devops-bash-tools']]])
      }
    }

    stage('Git Merge') {
      // applied before stage { agent{} }
//      options {
//        // includes agent wait time, agent availability delays could induce this stage to fail this way
//        timeout(time: 1, unit: 'HOURS')
//      }

      //when { branch pattern: '^refs/heads/staging$', comparator: 'REGEXP' }
      when { branch 'refs/heads/staging' }

      steps {
        milestone(ordinal: 20, label: "Milestone: Git Merge")
        timeout(time: 5, unit: 'MINUTES') {
          sh 'path/to/git_merge_staging_to_dev.sh'  // script in https://github.com/HariSekhon/DevOps-Bash-tools
        }
      }
    }

    stage('Setup') {
      steps {
        milestone(ordinal: 30, label: "Milestone: Setup")
        label 'Setup'
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
      }
    }

    // Parallelize build via multiple sub-stages if possible:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#parallel
    stage('Build') {
      // only apply env to this stage
      environment {
        DEBUG = '1'
      }
      // specify agent at stage level to build on different environments
//      agent {
//        label 'linux'
//      }

      steps {
        // forbids older builds from starting
        milestone(ordinal: 50, label: "Milestone: Build")
        // convenient in Blue Ocean to see the environment quickly in a separate expand box
        timeout(time: 1, unit: 'MINUTES') {
          sh script: 'env | sort', label: 'Environment'
        }
        //echo "${params.MyVar}"
        echo "Running ${env.JOB_NAME} Build ${env.BUILD_ID} on ${env.JENKINS_URL}"
        echo 'Building...'
        timeout(time: 60, unit: 'MINUTES') {
          sh 'make'
          // or
          sh './gcp_ci_build.sh'  // script in https://github.com/HariSekhon/DevOps-Bash-tools
//          retry(3) {
////            sh 'apt update -q'
////            sh 'apt install -qy make'
////            sh 'make init'
//            sh """
//              setup/ci_bootstrap.sh &&
//              make init
//            """
//          }
//        }
        }
//        timeout(time: 180, unit: 'MINUTES') {
//          sh 'make ci'
//        }
        // saves artifacts to Jenkins master for basic reporting and archival - not a substitute for Nexus / Artifactory
        // archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
      }
    }

    stage('Test') {
      //options {
      //  retry(2)
      //}
      steps {
        milestone(ordinal: 70, label: "Milestone: Test")
        echo 'Testing...'
        timeout(time: 60, unit: 'MINUTES') {
          sh 'make test'
          // junit '**/target/*.xml'
        }
      }
    }

//    stage('Human Gate') {
//      when {
//        // TODO: test with and without
//        // https://www.jenkins.io/doc/book/pipeline/syntax/#evaluating-when-before-the-input-directive
//        beforeInput true  // change order to evaluate when{} first to only prompt if this is on production branch
//        branch 'refs/heads/production'
//      }
//      steps {
//        milestone(ordinal: 85, label: "Milestone: Human Gate")
//        // by default input applies after options{} but before agent{} or when{}
//        // https://www.jenkins.io/doc/book/pipeline/syntax/#input
//        input "Proceed to deployment?"
//        input {
//          message "Proceed to deployment?"
//          submitter "platform-engineering@mycompany.co.uk"  // only allow people in platform engineering group to approve the human gate
//          submitterParameter SUBMITTER
//        }
//        echo "Deployment approved by ${SUBMITTER}"
//      }
//    }

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
      //when { branch pattern: '^refs/heads/production$', comparator: 'REGEXP' }
      //when { branch pattern: 'refs/heads/production' }
      when { branch 'refs/heads/production' }

      // prompt to deploy - use in separate stage Human Gate instead
      //input "Deploy?"

      // discard other deploys once this one has been chosen
      // use Lockable Resources plugin to limit deploy concurrency to 1
      // inversePrecedence: true makes Jenkins use the most recent deployment first, which when combined with Milestone, discards older deploys
      lock(resource: 'Deploy', inversePrecedence: true) {
        steps {
          // forbids older deploys from starting
          milestone(ordinal: 100, label: "Milestone: Deploy")
          echo 'Deploying...'
          // push artifacts and/or deploy to production
          timeout(time: 15, unit: 'MINUTES') {
            sh 'make deploy'
            // or
            sh './gcp_ci_deploy_k8s.sh'  // script in https://github.com/HariSekhon/DevOps-Bash-tools
          }
        }
      }

    stage('Deploy Canary') {
      // XXX: remember to escape backslashes (double backslash)
      //when { branch pattern: '^refs/heads/staging$', comparator: 'REGEXP' }
      when { branch 'refs/heads/staging' }

      echo 'Deploying Canary release...'
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
      when { branch 'refs/heads/production' }
      // XXX: remember to escape backslashes (double backslash)
      //when { branch pattern: '^refs/heads/production$', comparator: 'REGEXP' }

      echo 'Deploying Production release...'
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

  // ========================================================================== //
  //                                    P o s t
  // ========================================================================== //

  // https://www.jenkins.io/doc/book/pipeline/syntax/#post
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
      //      color: 'good',
      //      message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
    }
    failure {
      echo 'FAILURE!'
      //mail to: team@example.com, subject: 'The Pipeline failed :('
    }
    unstable {
      echo 'UNSTABLE!'
    }
    // only runs if status changed from last run
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
//  stage 'Checkout'
//
//  checkout scm
//
//  stage 'Gradle Static Analysis'
//  withSonarQubeEnv {
//    sh "./gradlew clean sonarqube"
//  }
//}
