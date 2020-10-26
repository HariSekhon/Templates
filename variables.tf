#  vim:ts=2:sts=2:sw=2:et
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

# XXX: set these in terraform.tfvars

variable "project" {
  #default = "myproject-123456"
}

variable "vpc_name" {
  #default = "default"
}

variable "region" {
  # AWS
  #
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#ec2_region
  #
  #default = "eu-west-1"

  # GCP
  #
  #   https://cloud.google.com/compute/docs/regions-zones#available
  #
  #default = "europe-west1"
}

variable "node_count" {
  # only accept integers/floats
  type = number
  #default = 2
}

variable "private_cidrs" {
  type = list
  #default = [
  #  "10.0.0.0/8",
  #  "172.16.0.0/16",
  #  "192.168.0.0/16"
  #]
}
