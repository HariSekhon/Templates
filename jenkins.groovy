//
//  Author: Hari Sekhon
//  Date: [% DATE # 2012-10-14 13:19:29 +0100 (Sun, 14 Oct 2012) %]
//
//  vim:ts=2:sts=2:sw=2:et
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
//                    Jenkins Groovy Shared Library Function
// ========================================================================== //

def call(Map args = [:]) {
  args.var = args.var ?: 'default_value'
  withEnv(["VAR=${args.var}"]){
    sh (
      label: 'MyLabel',
      script: '''
        set -eux
        echo "key = name, value = $VAR"
      '''
    )
  }
}
