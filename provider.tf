#  vim:ts=2:sts=2:sw=2:et
#
#  Author: Hari Sekhon
#  Date: 2020-02-03 13:37:32 +0000 (Mon, 03 Feb 2020)
#
#  https://github.com/harisekhon/templates
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn
#  and optionally send me feedback to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

# terraform 0.12+ doesn't use this surrounding block
#terraform {
# XXX: delete as necessary
required_providers {
  # 0.13+
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
  aws = {
    source  = "hashicorp/aws"
    version = "~> 3.7.0"
  }
  # https://www.terraform.io/docs/providers/google/index.html
  google = {
    source  = "hashicorp/google"
    version = "~> 3.40.0"
  }
  # https://www.terraform.io/docs/providers/azurerm/index.html
  azure = {
    source  = "hashicorp/azurerm"
    version = "~> 2.28.0"
  }
}
#}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  # set here in 0.12, set in required_providers in 0.13
  version = "~> 3.7.0"
  region  = var.region # eg. eu-west-1
}

# https://www.terraform.io/docs/providers/google/index.html
provider "google" {
  project = var.project
  region  = var.region # eg. europe-west1
}

provider "google-beta" {
  project = var.project
  region  = var.region
}

# https://www.terraform.io/docs/providers/azurerm/index.html
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~> 2.28.0"
  features {}
}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest
#provider "kubernetes" {}

# https://registry.terraform.io/providers/hashicorp/helm/latest
#provider "helm" {}
