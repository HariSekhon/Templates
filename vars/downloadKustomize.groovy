//
//  Author: Hari Sekhon
//  Date: 2021-09-01 11:57:48 +0100 (Wed, 01 Sep 2021)
//
//  vim:ts=4:sts=4:sw=4:noet
//
//  https://github.com/HariSekhon/Templates
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

def call(version='4.3.0'){
  timeout(time: 2, unit: 'MINUTES') {
    sh script: """#!/bin/bash
        set -euo pipefail
        echo "Downloading Kustomize version $version"
        curl -sSL -o /tmp/kustomize.\$\$.tgz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${version}/kustomize_v${version}_linux_amd64.tar.gz
        tar zxvf /tmp/kustomize.\$\$.tgz kustomize -O > /tmp/kustomize.\$\$
        chmod +x /tmp/kustomize.\$\$
        mv -iv /tmp/kustomize.\$\$ /usr/local/bin/kustomize
    """
  }
}
