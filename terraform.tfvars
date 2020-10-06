#  [% VIM_TAGS %]
#
#  Author: Hari Sekhon
#  Date: [% DATE # 2020-08-21 10:14:10 +0100 (Fri, 21 Aug 2020) %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

# AWS
#region   = "eu-west-1"

# GCP
project = "myproject-123456"
region  = "europe-west-1"

vpc_name = "default"

node_count = 3

private_cidrs = [
  "10.0.0.0/8",
  "172.16.0.0/16",
  "192.168.0.0/16"
  # XXX: set your 3rd party VPN provider's address range here for restricting access to these address ranges in firewall rules defined in main.tf
]
