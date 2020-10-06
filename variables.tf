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

# XXX: remove defaults to enforce use of terraform.tfvars

variable "project" {
  default = "myproject-123456" # XXX: EDIT
}

variable "vpc_name" {
  default = "default" # XXX: EDIT
}

variable "region" {
  # XXX: EDIT, delete one of
  # aws
  default = "eu-west-1"
  # gcp
  default = "europe-west1"
}

variable "node_count" {
  # only accept integers/floats
  type    = number
  default = 2
}
