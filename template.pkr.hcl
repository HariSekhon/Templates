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
  # Data sources only available in 1.7+
  required_version = ">= 1.7.0, < 2.0.0"
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
    #amazon = {
    #  version = ">= 1.2.5"
    #  source  = "github.com/hashicorp/amazon"
    #}
    #googlecompute = {
    #  version = ">= 1.1.1"
    #  source  = "github.com/hashicorp/googlecompute"
    #}
    #docker = {
    #  version = ">= 0.0.7"
    #  source  = "github.com/hashicorp/docker"
    #}
    #vmware = {
    #  version = ">= 1.0.8"
    #  source  = "github.com/hashicorp/vmware"
    #}
    # used to build remotely on ESXi
    #vsphere = {
    #  version = ">= 1.1.1"
    #  source  = "github.com/hashicorp/vsphere"
    #}
  }
}

# ============================================================================ #
#                               V a r i a b l e s
# ============================================================================ #

# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/variables

#   -var-files values.pkrvars.hcl  containing foo = "value"
#   *.auto.pkrvars.hcl
#   PKR_VAR_foo=bar

variable "foo" {
  type    = string
  default = "inline_bar"
}

variable "docker_image" {
  type    = string
  default = "ubuntu:22.04"
  #description = ""
  #sensitive = true
}

variable "aws_region" {
  default = env("AWS_DEFAULT_REGION")
}

variable "availability_zone_names" {
  type = list(string)
  default = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2c"
  ]
}

variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 8300
      external = 8300
      protocol = "tcp"
    }
  ]
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
#                         L o c a l   V a r i a b l e s
# ============================================================================ #

# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/locals

# locals are like constants and unlike variables cannot be overridden at runtime

# can't be used within data sources as of Packer 1.8

locals {
  foo = "bar"
  #baz = "Foo is '${var.foo}'"

  #default_name_prefix = "${var.project_name}-web"
  #name_prefix         = "${var.name_prefix != "" ? var.name_prefix : local.default_name_prefix}"

  settings_file  = "${path.cwd}/settings.txt" # path.cwd  = 'packer' commands's $PWD
  scripts_folder = "${path.root}/scripts"     # path.root = is the dirname(file.pkr.hcl)
  root           = path.root

  # locals can access data sources but data sources cannot access locals, to prevent circular dependencies
  #source_ami_id   = data.amazon-ami.example.id
  #source_ami_name = data.amazon-ami.example.name

  #value         = data.amazon-secretsmanager.basic-example.value
  #secret_string = data.amazon-secretsmanager.basic-example.secret_string
  #version_id    = data.amazon-secretsmanager.basic-example.version_id
  #secret_value  = jsondecode(data.amazon-secretsmanager.basic-example.secret_string)["packer_test_key"]

  common_tags = {
    Component   = "awesome-app"
    Environment = "production"
  }

  # requires AWS profile / access key to be found, else errors out
  #
  # set second arg to the key if secret had multiple keys, else set to null
  #secret = aws_secretsmanager("my_secret", null)  # always pulls latest version AWSCURRENT, previous versions not supported

  #my_version = "${consul_key("myservice/version")}"

  # requires VAULT_TOKEN and VAULT_ADDR environment variables to be set
  #
  #foo2 = vault("/secret/data/hello", "foo")
}

# Use the singular local block if you need to mark a local as sensitive
local "mylocal" {
  expression = "${var.docker_image}"
  sensitive  = true
}


# ============================================================================ #
#                            D a t a   S o u r c e s
# ============================================================================ #

# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/datasources

# locals can access data sources but data sources cannot access locals, to prevent circular dependencies

# https://developer.hashicorp.com/packer/plugins/datasources/external/external

# https://developer.hashicorp.com/packer/plugins/datasources/amazon

# https://developer.hashicorp.com/packer/plugins/datasources/amazon/ami
#data "amazon-ami" "example" {
#  filters = {
#    virtualization-type = "hvm"
#    name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
#    root-device-type    = "ebs"
#  }
#  owners      = ["099720109477"]
#  most_recent = true
#}

# https://developer.hashicorp.com/packer/plugins/datasources/amazon/secretsmanager
#data "amazon-secretsmanager" "basic-example" {
#  name          = "packer_test_secret"
#  key           = "packer_test_key"
#  version_stage = "example"
#}

# foo = data.http.example.body
#data "http" "example" {
#  url = "https://checkpoint-api.hashicorp.com/v1/check/terraform"
#
#  # Optional request headers
#  request_headers = {
#    Accept = "application/json"
#  }
#}


# ============================================================================ #
#                                 S o u r c e s
# ============================================================================ #

# Create multiple sources to build near identical images for different platforms

# https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso
source "virtualbox-iso" "NAME" {
  vm_name = "NAME" # XXX: Edit Name, default: packer-BUILDNAME eg. packer-NAME - name of the OVF file without the extension
  # VBoxManage list ostypes
  #guest_os_type = "Ubuntu22_LTS_64"
  guest_os_type = "Ubuntu_64"
  # Browse to http://releases.ubuntu.com/ and pick the latest LTS release
  iso_url              = "http://releases.ubuntu.com/jammy/ubuntu-22.04.2-live-server-amd64.iso"
  iso_checksum         = "5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
  cpus                 = 1     # default: 1
  memory               = 15136 # MB, default: 512 - too low RAM results in 'Kernel panic - not syncing: No working init found.'
  disk_size            = 40000 # default: 40000 MB = around 40GB
  disk_additional_size = []    # add MiB sizes, disks will be called ${vm_name}-# where # is the incrementing integer
  # https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso#boot-configuration
  boot_wait = "10s" # default: 10s
  boot_command = [
    #" <tab><wait>",
    #" ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos8-ks.cfg<enter>"
    #" autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/"
  ]
  #boot_command = [
  #  "<esc><esc><enter><wait>",
  #  "/install/vmlinuz noapic ",
  #  "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
  #  "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
  #  "hostname={{ .Name }} ",
  #  "fb=false debconf/frontend=noninteractive ",
  #  "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
  #  "keyboard-configuration/variant=USA console-setup/ask_detect=false ",
  #  "initrd=/install/initrd.gz -- <enter>"
  #]
  #communicator = "none"  # doesn't work to to allow a first manual install to collect /var/log/installer/autoinstall-user-data, must instead use -debug
  #guest_additions_mode    = "upload"
  guest_additions_mode    = "disable"  # must be disabled when using communicator = 'none'
  #guest_additions_path    = "VBoxGuestAdditions.iso"
  # doesn't work to set this higher to allow a first manual install to collect /var/log/installer/autoinstall-user-data
  # gets an SSH authentication error a couple minutes in and kills the VM regardless
  #ssh_timeout  = "30m"  # default: 5m - waits 5 mins for SSH to come up otherwise kills VM
  ssh_username = "packer"
  ssh_password = "packer"
  # needed to ensure filesystem is fsync'd
  shutdown_command        = "echo 'packer' | sudo -S shutdown -P now"
  rtc_time_base           = "UTC"
  #virtualbox_version_file = ".vbox_version" # file created in $HOME directory to indicate which version of VirtualBox created this
  virtualbox_version_file = "" # must be an empty string when using communicator = 'none'
  bundle_iso              = false           # keep the ISO attached
  # extra CLI customization
  #vboxmanage = [
  #  ["modifyvm", "{{.Name}}", "--cpus", "2"],
  #  ["modifyvm", "{{.Name}}", "--memory", "1024"],
  #]
  export_opts = [
    "--manifest",
    "--vsys", "0",
    #"--description", "${var.vm_description}",  # create variables if uncommenting these
    #"--version", "${var.vm_version}"
  ]
  format = "ova"
  #output_directory = "" # default: 'output-BUILDNAME', must not already exist
  #output_filename  = "" # default: '${vm_name}'
}

# https://developer.hashicorp.com/packer/plugins/builders/virtualbox/ovf
#source "virtualbox-ovf" "NAME" {
#  vm_name                 = "NAME" # default: packer-BUILDNAME eg. packer-NAME - name of the OVF file without the extension
#  source_path             = "source.ovf"
#  ssh_username            = "packer"
#  ssh_password            = "packer"
#  shutdown_command        = "echo 'packer' | sudo -S shutdown -P now"
#  virtualbox_version_file = ".vbox_version" # file created in $HOME directory to indicate which version of VirtualBox created this
#  guest_additions_mode    = "upload"
#  guest_additions_path    = "VBoxGuestAdditions.iso"
#  # extra CLI customization
#  #vboxmanage = [
#  #  ["modifyvm", "{{.Name}}", "--cpus", "2"],
#  #  ["modifyvm", "{{.Name}}", "--memory", "1024"],
#  #]
#  export_opts = [
#    "--manifest",
#    "--vsys", "0",
#    #"--description", "${var.vm_description}",  # create variables if uncommenting these
#    #"--version", "${var.vm_version}"
#  ]
#  format = "ova"
#  #output_directory = "" # default: 'output-BUILDNAME', must not already exist
#  #output_filename  = "" # default: '${vm_name}'
#}

# https://developer.hashicorp.com/packer/plugins/builders/docker
#source "docker" "ubuntu" {
#  image  = var.docker_image
#  commit = true
#}

# https://developer.hashicorp.com/packer/plugins/builders/vagrant
#source "vagrant" "ubuntu" {
#  source_path = "hashicorp/precise64"
#  provider    = "virtualbox"
#}

# https://developer.hashicorp.com/packer/plugins/builders/amazon
#source "amazon-ebs" "basic-example" {
#  source_ami = locals.source_ami
#  // ...
#}


# ============================================================================ #
#                                   B u i l d
# ============================================================================ #

# https://developer.hashicorp.com/packer/plugins/builders/virtualbox

# https://developer.hashicorp.com/packer/plugins/builders/vagrant

# https://developer.hashicorp.com/packer/plugins/post-processors/vagrant/vagrant

# https://developer.hashicorp.com/packer/plugins/builders/amazon

# https://developer.hashicorp.com/packer/plugins/builders/azure

# https://developer.hashicorp.com/packer/plugins/builders/googlecompute

# https://developer.hashicorp.com/packer/plugins/builders/vmware

# https://developer.hashicorp.com/packer/plugins/builders/vsphere/vsphere-iso

build {
  name = "NAME"

  # specify multiple sources defined above to build near identical images for different platforms
  sources = [
    "source.virtualbox-iso.NAME"
    #"sources.virtualbox-ovf.NAME"
  ]

  # https://developer.hashicorp.com/packer/docs/provisioners/file
  #
  #provisioner "file" {
  #  source = "app.tar.gz"
  #  destination = "/tmp/app.tar.gz"
  #}
  #
  #provisioner "file" {
  #  sources = ["file1.txt", "file2.txt"]
  #  destination = "/etc/conf/"
  #}

  #provisioner "file" {
  #  content     = "Built using Packer version '${packer.version}'"
  #  destination = "/etc/packer-version"
  #}

  # https://developer.hashicorp.com/packer/plugins/provisioners/ansible/ansible
  #
  #provisioner "ansible" {
  #  playbook_file = "./playbook.yml"
  #  ansible_env_vars = [
  #    "ANSIBLE_HOST_KEY_CHECKING=False",
  #    "ANSIBLE_SSH_ARGS='-o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s'",
  #    #"ANSIBLE_NOCOLOR=True"
  #  ]
  #}

  # https://developer.hashicorp.com/packer/docs/provisioners/breakpoint
  #
  #   when -debug switch this pauses to be able to debug the build
  #
  #provisioner "breakpoint" {
  #  disable = false
  #  note    = "this is a breakpoint to be able to inspect the VM contents"
  #}

  # https://developer.hashicorp.com/packer/docs/provisioners/shell-local
  #
  provisioner "shell-local" {
    # https://developer.hashicorp.com/packer/docs/templates/hcl_templates/contextual-variables
    # can access:
    #   source variables name and type
    #   build variables name, ID, Host, Port, User and Password (for passing to Ansible),
    #                   ConnType (eg. "ssh"), SSHPublicKey, SSHPrivateKey, PackerRunUUID,
    #                   PackerHTTPIP / PackerHTTPPort / PackerHTTPAddr (IP:PORT) of the http file server packer runs to serve files to the VM
    inline = [
      "echo Build UUID ${build.PackerRunUUID}",
      "echo Source '${source.name}' type '${source.type}'",
    ]
  }

  # https://developer.hashicorp.com/packer/docs/provisioners/shell
  #
  #provisioner "shell" {
  #  #script = "/path/to/script.sh"
  #  #script = "./script.sh"
  #  #scripts = [
  #  #  "/path/to/script.sh",
  #  #  "./script.sh"
  #  #]
  #  environment_vars = [
  #    "FOO=bar"
  #  ]
  #  inline = [
  #    "echo Built using Packer version '${packer.version}' | tee /etc/packer-version"
  #    #"echo '${build.SSHPrivateKey}' > /tmp/packer-session.pem"  # temporary SSH private key eg. git clone a private repo git@github.com:org/repo
  #  ]
  #  # max_retries = 5
  #  # timeout = "5m"
  #}

  # post-processors (plural) creates a serial post-processing where one post-processor's output is the next one's input
  #post-processors {
  #  # vagrant post-processor cannot be used with vagrant builder as it'll clash
  #  post-processor "vagrant" {}
  #  post-processor "compress" {}
  #}

  # post-processor blocks run in parallel
  #
  post-processor "checksum" {               # checksum image
    checksum_types      = ["md5", "sha512"] # checksum the artifact
    keep_input_artifact = true              # keep the artifact
  }

  # https://developer.hashicorp.com/packer/plugins/post-processors/docker/docker-tag
  #post-processor "docker-tag" {
  #  repository = "myrepo"  # XXX: Edit
  #  tags       = ["ubuntu", "mytag"]
  #  only       = ["docker.ubuntu"]
  #}
  #post-processor "docker-tag" {
  #  repository = "learn-packer"
  #  tags       = ["ubuntu-othersource", "packer-rocks"]
  #  only       = ["docker.othersource"]
  #}

  # happen in serial
  #post-processors {
  #  post-processor "docker-import" {
  #    repository = "swampdragons/testpush"
  #    tag        = "0.7"
  #  }
  #  # https://developer.hashicorp.com/packer/plugins/post-processors/docker/docker-push
  #  post-processor "docker-push" {}
  #}
}
