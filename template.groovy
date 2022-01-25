#!/usr/bin/env groovy
//
//  Author: Hari Sekhon
//  Date: [% DATE # 2012-10-14 13:19:29 +0100 (Sun, 14 Oct 2012) %]
//
//  vim:ts=4:sts=4:sw=4:noet
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
//                                  G r o o v y
// ========================================================================== //

// Jenkins Shared Library function
def call(Map args = [:]) {
    sh 'echo "key = name, value = ${args.name}" '
}

// ================
// Groovy Scripting
//
// http://docs.groovy-lang.org/latest/html/documentation/grape.html
@GrabConfig(systemClassLoader=true)
@Grab(group='mysql', module='mysql-connector-java', version='5.1.6')


// =====================
// or old class stuff
class [% NAME %] {

    static void main(String[] args) throws Exception {

    }

}
