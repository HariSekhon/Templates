#
#  Author: Hari Sekhon
#  Date: [% DATE  # 2023-05-28 15:50:29 +0100 (Sun, 28 May 2023) %]
#
#  vim:ts=2:sts=2:sw=2:et:filetype=conf
#
#  https://github.com/HariSekhon/Templates
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

# ============================================================================ #
#                                  P a c k e r
# ============================================================================ #

packer {
  required_version = ">= 1.7.0, < 2.0.0"
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

# ============================================================================ #
#
#   -var-files values.pkrvars.hcl  containing foo = "value"
#   *.auto.pkrvars.hcl
#   PKR_VAR_foo=bar

variable "docker_image" {
  type    = string
  default = "ubuntu:22.04"
  #description = ""
  #sensitive = true
}

variable "aws_region" {
  default = env("AWS_DEFAULT_REGION")
}

variable "image_id" {
  type        = string
  default     = "ami-....."
  description = "The ID of the machine image (AMI) to use for the server."

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI ID, starting with \"ami-\"."
  }
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^ami-", var.image_id))
    error_message = "The image_id value must be a valid AMI ID, starting with \"ami-\"."
  }
}

# complex data type and validation
variable "image_metadata" {

  default = {
    key : "value",
    something : {
      foo : "bar",
    }
  }

  validation {
    condition     = length(var.image_metadata.key) > 4
    error_message = "The image_metadata.key field must be more than 4 runes."
  }

  validation {
    condition     = can(var.image_metadata.something.foo)
    error_message = "The image_metadata.something.foo field must exist."
  }

  validation {
    condition     = substr(var.image_metadata.something.foo, 0, 3) == "bar"
    error_message = "The image_metadata.something.foo field must start with \"bar\"."
  }

}

# ============================================================================ #
# locals.pkr.hcl

locals {
  foo = "bar"
  #baz = "Foo is '${var.foo}'"

  # requires AWS profile / access key to be found, else errors out
  #
  # set second arg to the key if secret had multiple keys, else set to null
  #secret = aws_secretsmanager("my_secret", null)  # always pulls latest version AWSCURRENT, previous versions not supported

  #my_version = "${consul_key("myservice/version")}"

  #foo2 = vault("/secret/data/hello", "foo")
}

# Use the singular local block if you need to mark a local as sensitive
local "mylocal" {
  expression = "${var.docker_image}"
  sensitive  = true
}

# ============================================================================ #

# Create multiple sources to build near identical images for different platforms
source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

# ============================================================================ #
build {
  name = "learn-packer"

  # specify multiple sources defined above to build near identical images for different platforms
  sources = [
    "source.docker.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
    # max_retries = 5
    # timeout = "5m"
  }

  # post-processors (plural) creates a serial post-processing where one post-processor's output is the next one's input
  post-processors {
    post-processor "vagrant" {}
    post-processor "compress" {}
  }

  post-processor "checksum" {               # checksum image
    checksum_types      = ["md5", "sha512"] # checksum the artifact
    keep_input_artifact = true              # keep the artifact
  }

  # these 2 post-processors happen in parallel
  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = ["ubuntu", "mytag"]
    only       = ["docker.ubuntu"]
  }
  #post-processor "docker-tag" {
  #  repository = "learn-packer"
  #  tags       = ["ubuntu-othersource", "packer-rocks"]
  #  only       = ["docker.othersource"]
  #}

  # happen in serial
  post-processors {
    post-processor "docker-import" {
      repository = "swampdragons/testpush"
      tag        = "0.7"
    }
    post-processor "docker-push" {}
  }
}
