#  [% VIM_TAGS %]
#
#  Author: Hari Sekhon
#  Date: [% DATE # 2020-08-21 10:23:27 +0100 (Fri, 21 Aug 2020) %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

terraform {
  # XXX: remember to enable Object Versioning on this bucket for state recovery - https://cloud.google.com/storage/docs/object-versioning
  backend "gcs" {
    bucket = "NAME-prod-tf-state"  # XXX: EDIT
    prefix  = "terraform/state"
  }

  # default backend
  #backend "local" {
  #  path = "./terraform.tfstate"
  #}

  # Terraform Cloud
#  backend "remote" {
#    hostname = "app.terraform.io"
#    organization = "mycompany"  # XXX: EDIT
#
#    workspaces {
#      # XXX: EDIT
#      # single workspace
#      name = "my-app-prod"
#      # or multiple workspaces
#      prefix = "my-app-"
#    }
#  }
}
