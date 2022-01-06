//
//  Author: Hari Sekhon
//  Date: 2022-01-06 17:10:38 +0000 (Thu, 06 Jan 2022)
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

def call(timeoutMinutes=10){
  label 'tfsec'
  container('tfsec') {
    steps {
      //dir ("components/${COMPONENT}") {
      ansiColor('xterm') {
        // aquasec/tfsec image is based on Alpine, doesn't have bash
        //sh '''#!/usr/bin/env bash -euxo pipefail
        sh '''#!/bin/sh -eux
        tfsec --update
        tfsec --version
        tfsec --run-statistics  # nice summary table
        tfsec --soft-fail       # don't error
        tfsec                   # full details and error out if issues found
        '''
      }
    }
  }
}
