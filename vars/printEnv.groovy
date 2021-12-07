//
//  Author: Hari Sekhon
//  Date: 2021-08-31 17:53:01 +0100 (Tue, 31 Aug 2021)
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

def call(){
  timeout(time: 1, unit: 'MINUTES') {
    //sh script: 'env | sort', label: 'Environment'
    label: 'Environment'
    sh '''#!/bin/bash
      set -euxo pipefail
      env | sort
    '''
  }
}
