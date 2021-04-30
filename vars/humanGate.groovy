//
//  Author: Hari Sekhon
//  Date: 2021-04-30 15:25:01 +0100 (Fri, 30 Apr 2021)
//
//  vim:ts=2:sts=2:sw=2:et
//
//  https://github.com/HariSekhon/DevOps-Bash-tools
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

def call(){
  milestone ordinal: 20, label: "Milestone: Human Gate"
  // only wait for 1 hour because we don't want to approve release but not give it enough time to succeed, better to retry the build from start
  timeout(time: 1, unit: 'HOURS') {
    input (
      message: """Are you sure you want to release this build to production?

This prompt will time out after 1 hour""",
      ok: "Deploy",
      // only allow people in this group to approve deployments to production
      submitter: "platform-engineering@mycompany.co.uk",
    )
  }
}
