#!/usr/bin/env packer build --force
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

# Uses adjacent Redhat Kickstart, Debian Preseed & Ubuntu Autoinstaller
#
# 'packer' command must be run from the same directory as the provided adjacent files which are auto-served via HTTP:
#
# - Redhat Kickstart     - anaconda-ks.cfg
# - Debian Preseed       - preseed.cfg
# - Ubuntu AutoInstaller - autoinstall-user-data and meta-data files

# ============================================================================ #
#                        H a s h i C o r p   P a c k e r
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
  #source_ami_id   = data.amazon-ami.ubuntu.id
  #source_ami_name = data.amazon-ami.ubuntu.name

  #value         = data.amazon-secretsmanager.NAME.value
  #secret_string = data.amazon-secretsmanager.NAME.secret_string
  #version_id    = data.amazon-secretsmanager.NAME.version_id
  #secret_value  = jsondecode(data.amazon-secretsmanager.NAME.secret_string)["packer_test_key"]

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
#data "amazon-ami" "ubuntu" {
#  filters = {
#    virtualization-type = "hvm"
#    name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
#    root-device-type    = "ebs"
#  }
#  owners      = ["099720109477"]
#  most_recent = true
#}

# https://developer.hashicorp.com/packer/plugins/datasources/amazon/secretsmanager
#data "amazon-secretsmanager" "NAME" {
#  name          = "packer_test_secret"
#  key           = "packer_test_key"
#  version_stage = "example"
#}

# foo = data.http.NAME.body
#data "http" "NAME" {
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

# Debian's installer is the fastest and most lightweight
# Ubuntu and Fedora are allocated more resources to try to prevent them stalling / crashing
# Fedora's anaconda installer is the most resource hungry and unrealiable when resource constrained

# https://developer.hashicorp.com/packer/plugins/builders/qemu
source "qemu" "ubuntu" {
  vm_name     = "ubuntu"             # name of the OVF file without the extension, default: packer-<buildname>-<epoch> eg. packer-ubuntu-1685455208
  qemu_binary = "qemu-system-x86_64" # default: qemu-system-x86_64, change for ARM eg. Mac M1/M2
  #use_default_display = true  # might be needed on Mac to avoid errors about sdl not being available
  accelerator = "kvm"
  # VBoxManage list ostypes
  #guest_os_type = "Ubuntu22_LTS_64"
  #guest_os_type = "Ubuntu_64"
  # Browse to http://releases.ubuntu.com/ and pick the latest LTS release
  iso_url      = "http://releases.ubuntu.com/jammy/ubuntu-22.04.2-live-server-amd64.iso"
  iso_checksum = "5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
  # ARM
  #iso_url              = "https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.2-live-server-arm64.iso"
  #iso_checksum         = "12eed04214d8492d22686b72610711882ddf6222b4dc029c24515a85c4874e95"
  #cpus                 = 3     # default: 1
  memory               = 3072  # MB, default: 512 - too low RAM results in 'Kernel panic - not syncing: No working init found.'
  disk_size            = 40960 # default: 40960, uses MB if no suffix, but suffixes cause this comment to fail validation with this error: 'An argument definition must end with a newline.'
  disk_additional_size = []    # add MiB sizes, disks will be called ${vm_name}-# where # is the incrementing integer
  http_directory       = "."   # necessary for the user-data to be served out for autoinstall boot_command
  #http_directory       = "${path.root}" # doesn't work
  # https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso#boot-configuration
  boot_wait = "5s" # default: 10s
  boot_command = [
    #"<tab><wait>",
    #"ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos8-ks.cfg<enter>"
    #"autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ <enter>"
    "c<wait>",
    # XXX: must single quotes the ds=... arg to prevent grub from interpreting the semicolon as a terminator
    # https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html
    "linux /casper/vmlinuz autoinstall 'ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/' <enter><wait>",
    "initrd /casper/initrd <enter><wait>",
    "boot <enter>"
  ]
  # =====================================
  # Debug AutoInstaller failure to launch
  # XXX: need to set communicator to none to buy time to default autoinstaller issues otherwise default SSHd gets started and Packer creds get rejected so kills the VM
  #communicator            = "none"  # doesn't work to to allow a first manual install to collect /var/log/installer/autoinstall-user-data, must instead use -debug
  #disable_shutdown        = true
  #shutdown_timeout        = "2h"  # prevent the VM from being killed after 5 mins waiting for shutdown
  #guest_additions_mode    = "disable" # must be disabled when using communicator = 'none'
  #virtualbox_version_file = "" # must be an empty string when using communicator = 'none'
  # =====================================
  #guest_additions_mode    = "upload"
  #guest_additions_path    = "VBoxGuestAdditions.iso"
  # doesn't work to set this higher to allow a first manual install to collect /var/log/installer/autoinstall-user-data
  # gets an SSH authentication error a couple minutes in and kills the VM regardless
  ssh_timeout  = "30m" # default: 5m - waits 5 mins for SSH to come up otherwise kills VM
  ssh_username = "packer"
  ssh_password = "packer"
  # needed to ensure filesystem is fsync'd
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  net_device       = "virtio-net"
  disk_interface   = "virtio"
  #format            = "qcow2"
  format = "ova"
  #disk_compression  = true # default: false
  #rtc_time_base    = "UTC"
  #bundle_iso = false # keep the ISO attached
  qemuargs = []
  #output_directory = "" # default: 'output-BUILDNAME', must not already exist
  #output_filename  = "" # default: '${vm_name}'
}

# ============================================================================ #
#                      V i r t u a l B o x   S o u r c e s
# ============================================================================ #

# WARNING: XXX: Do not build on ARM M1/M2 Macs using VirtualBox 7.0 - as of 2023 VirtualBox 7.0 Beta is extremely buggy, slow,
#               results in "Aborted" VMs and so slow it even misses bootloader keystrokes - it is unworkable on ARM as of this date

# https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso
source "virtualbox-iso" "ubuntu" {
  vm_name = "ubuntu" # name of the OVF file without the extension, default: packer-<buildname>-<epoch> eg. packer-ubuntu-1685455208
  # VBoxManage list ostypes
  #guest_os_type = "Ubuntu22_LTS_64"
  guest_os_type = "Ubuntu_64"
  # Browse to http://releases.ubuntu.com/ and pick the latest LTS release
  iso_url      = "http://releases.ubuntu.com/jammy/ubuntu-22.04.2-live-server-amd64.iso"
  iso_checksum = "5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
  # ARM - DO NOT USE EVEN ON M1/M2 Macs - as of VirtualBox 7.0 in 2023 it seems to be emulating x86_64, not arm64, and results in the following error:
  #
  #     Could not read from the boot medium!
  #     Please insert a bootable medium and reboot.
  #
  # Switching back to x86_64 works but is even slower than on an older Intel Mac, probably due to the software emulation, and often ends up aborting due to the Beta nature of the 7.0 Virtualbox release for arm
  #
  #iso_url              = "https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.2-live-server-arm64.iso"
  #iso_checksum         = "12eed04214d8492d22686b72610711882ddf6222b4dc029c24515a85c4874e95"
  cpus                 = 3     # default: 1
  memory               = 3072  # MB, default: 512 - too low RAM results in 'Kernel panic - not syncing: No working init found.'
  disk_size            = 40000 # default: 40000 MB = around 40GB
  disk_additional_size = []    # add MiB sizes, disks will be called ${vm_name}-# where # is the incrementing integer
  http_directory       = "."   # necessary for the user-data to be served out for autoinstall boot_command
  #http_directory       = "${path.root}" # doesn't work
  # https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso#boot-configuration
  boot_wait = "5s" # default: 10s
  boot_command = [
    #"<tab><wait>",
    #"ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos8-ks.cfg<enter>"
    #"autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ <enter>"
    "c<wait>",
    # XXX: must single quotes the ds=... arg to prevent grub from interpreting the semicolon as a terminator
    # https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html
    "linux /casper/vmlinuz autoinstall 'ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/' <enter><wait>",
    "initrd /casper/initrd <enter><wait>",
    "boot <enter>"
  ]
  # =====================================
  # Debug AutoInstaller failure to launch
  # XXX: need to set communicator to none to buy time to default autoinstaller issues otherwise default SSHd gets started and Packer creds get rejected so kills the VM
  #communicator            = "none"  # doesn't work to to allow a first manual install to collect /var/log/installer/autoinstall-user-data, must instead use -debug
  #disable_shutdown        = true
  #shutdown_timeout        = "2h"  # prevent the VM from being killed after 5 mins waiting for shutdown
  #guest_additions_mode    = "disable" # must be disabled when using communicator = 'none'
  #virtualbox_version_file = "" # must be an empty string when using communicator = 'none'
  # =====================================
  #guest_additions_mode    = "upload"
  #guest_additions_path    = "VBoxGuestAdditions.iso"
  # doesn't work to set this higher to allow a first manual install to collect /var/log/installer/autoinstall-user-data
  # gets an SSH authentication error a couple minutes in and kills the VM regardless
  ssh_timeout  = "30m" # default: 5m - waits 5 mins for SSH to come up otherwise kills VM
  ssh_username = "packer"
  ssh_password = "packer"
  # needed to ensure filesystem is fsync'd
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  rtc_time_base    = "UTC"
  #virtualbox_version_file = ".vbox_version" # file created in $HOME directory to indicate which version of VirtualBox created this
  bundle_iso = false # keep the ISO attached
  # extra CLI customization
  vboxmanage = [
    #["modifyvm", "{{.Name}}", "--cpus", "2"],
    #["modifyvm", "{{.Name}}", "--memory", "1024"],
    # Error executing command: VBoxManage error: VBoxManage: error: Machine 'NAME' is not currently running.
    # do this in shell-local later
    #["sharedfolder", "add", "{{.Name}}", "--name", "vboxsf", "--hostpath", "~/vboxsf", "--automount", "--transient"],
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"], # XXX: workaround for auto-installer hanging at AppArmour Load
    # doesn't work - just set global preferences to 300% scale
    #["setextradata", "{{.Name}}", "CustomVideoMode1", "1400x1050x16"]  # make resolution bigger
    #["controlvm", "{{.Name}}", "setvideomodehint", "1400", "1050", "32"]  # doesn't work because VM isn't running at this point, and would require a reboot
  ]
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

# https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso
source "virtualbox-iso" "debian" {
  vm_name       = "debian"
  guest_os_type = "Debian_64"
  # https://www.debian.org/CD/http-ftp/
  iso_url      = "https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-11.7.0-amd64-DVD-1.iso" # 4.7GB
  iso_checksum = "cfbb1387d92c83f49420eca06e2d11a23e5a817a21a5d614339749634709a32f"
  #iso_url      = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.7.0-amd64-netinst.iso"  # 300MB
  #iso_checksum = "eb3f96fd607e4b67e80f4fc15670feb7d9db5be50f4ca8d0bf07008cb025766b"
  # ARM - DO NOT USE EVEN ON M1/M2 Macs - as of VirtualBox 7.0 in 2023 it seems to be emulating x86_64, not arm64, and results in the following error:
  #
  #     Could not read from the boot medium!
  #     Please insert a bootable medium and reboot.
  #
  # Switching back to x86_64 works but is even slower than on an older Intel Mac, probably due to the software emulation, and often ends up aborting due to the Beta nature of the 7.0 Virtualbox release for arm
  #
  #iso_url              = "https://cdimage.debian.org/debian-cd/current/arm64/iso-dvd/debian-11.7.0-arm64-DVD-1.iso"   # 4.7GB
  #iso_checksum         = "3b0d304379b671d7b7091631765f87e1cbb96b9f03f8e9a595a2bf540c789f3f"
  #iso_url              = "https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/debian-11.7.0-arm64-netinst.iso"  # 300MB
  #iso_checksum         = "174caba674fe3172938439257156b9cb8940bb5fd5ddf124256e81ec00ec460d"
  cpus                 = 2     # default: 1
  memory               = 2048  # MB, default: 512 - too low RAM results in 'Kernel panic - not syncing: No working init found.'
  disk_size            = 40000 # default: 40000 MB = around 40GB
  disk_additional_size = []    # add MiB sizes, disks will be called ${vm_name}-# where # is the incrementing integer
  http_directory       = "."   # necessary for the user-data to be served out for autoinstall boot_command
  # https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso#boot-configuration
  boot_wait = "5s" # default: 10s
  # Aliases useful with preseeding
  # https://www.debian.org/releases/stable/amd64/apbs02.en.html
  boot_command = [
    "<down><wait>",
    "<tab><wait>",
    # preseed-md5=... add later
    "fb=true auto=true url=http://{{.HTTPIP}}:{{.HTTPPort}}/preseed.cfg hostname={{.Name}} domain=local <enter>"
  ]
  ssh_timeout      = "30m" # default: 5m - waits 5 mins for SSH to come up otherwise kills VM
  ssh_username     = "packer"
  ssh_password     = "packer"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  rtc_time_base    = "UTC"
  bundle_iso       = false # keep the ISO attached
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"], # XXX: can't access host HTTP server for preseed.cfg file without this
  ]
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

# https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso
source "virtualbox-iso" "fedora" {
  vm_name       = "fedora"
  guest_os_type = "Fedora_64"
  # https://alt.fedoraproject.org/alt/
  iso_url      = "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Server/x86_64/iso/Fedora-Server-dvd-x86_64-38-1.6.iso"
  iso_checksum = "09dee2cd626a269aefc67b69e63a30bd0baa52d4"
  # ARM - DO NOT USE EVEN ON M1/M2 Macs - as of VirtualBox 7.0 in 2023 it seems to be emulating x86_64, not arm64, and results in the following error:
  #
  #     Could not read from the boot medium!
  #     Please insert a bootable medium and reboot.
  #
  # Switching back to x86_64 works but is even slower than on an older Intel Mac, probably due to the software emulation, and often ends up aborting due to the Beta nature of the 7.0 Virtualbox release for arm
  #
  #iso_url              = "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Server/aarch64/iso/Fedora-Server-dvd-aarch64-38-1.6.iso" # 2.8GB
  #iso_checksum         = "4cdf077eddaeedf1180cdf3e14213da2abc10ceb"
  cpus                 = 3     # default: 1
  memory               = 3072  # MB, default: 512 - too low RAM results in 'Kernel panic - not syncing: No working init found.'
  disk_size            = 40000 # default: 40000 MB = around 40GB
  disk_additional_size = []    # add MiB sizes, disks will be called ${vm_name}-# where # is the incrementing integer
  http_directory       = "."   # necessary for the user-data to be served out for autoinstall boot_command
  # https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso#boot-configuration
  boot_wait = "5s" # default: 10s
  # trigger GUI install - mouse isn't working, move to text-mode first install to collect a baseline anaconda-ks.cfg
  #boot_command = [
  #  "<up><wait><enter>",
  #]
  # trigger text mode install
  #boot_command = [
  #  "<up><wait>",
  #  "e",
  #  "<down><down><down><left>",
  #  # leave a space from last arg
  #  " inst.text <f10>" # trigger text mode install
  #]
  # Kickstart automated install
  boot_command = [
    "<up><wait>",
    "e",
    "<down><down><down><left>",
    # leave a space from last arg
    " inst.ks=http://{{.HTTPIP}}:{{.HTTPPort}}/anaconda-ks.cfg <f10>"
  ]
  ssh_timeout      = "30m" # default: 5m - waits 5 mins for SSH to come up otherwise kills VM
  ssh_username     = "packer"
  ssh_password     = "packer"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  rtc_time_base    = "UTC"
  bundle_iso       = false # keep the ISO attached
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"], # XXX: can't access host HTTP server for kickstart file without this
  ]
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

# ============================================================================ #
# https://developer.hashicorp.com/packer/plugins/builders/virtualbox/ovf
#source "virtualbox-ovf" "ubuntu" {
#  vm_name                 = "ubuntu"
#  source_path             = "source.ovf"
#  ssh_username            = "packer
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
#source "docker" "NAME" {
#  image  = var.docker_image
#  commit = true
#}

# https://developer.hashicorp.com/packer/plugins/builders/vagrant
#source "vagrant" "ubuntu" {
#  source_path = "hashicorp/precise64"
#  provider    = "virtualbox"
#}

# https://developer.hashicorp.com/packer/plugins/builders/amazon
#source "amazon-ebs" "NAME" {
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
  name = "ubuntu"

  # specify multiple sources defined above to build near identical images for different platforms
  sources = [
    "source.virtualbox-iso.ubuntu",
    #"sources.virtualbox-ovf.ubuntu"
  ]

  provisioner "file" {
    source = "/var/log/installer/autoinstall-user-data"
    # if you let this overwrite the real one, it'l break subsequent runs like so because it'll remove the early commands to stop the SSHd server daemon during installer:
    # Error waiting for SSH: Packer experienced an authentication error when trying to connect via SSH. This can happen if your username/password are wrong. You may want to double-check your credentials as part of your debugging process. original error: ssh: handshake failed: ssh: unable to authenticate, attempted methods [none password], no supported methods remain
    destination = "autoinstall-user-data.new"
    direction   = "download"
  }

  # doesn't help to put a breakpoint here because Packer insists on testing for SSH and as soon as it gets auth rejected destroys the VM anyway
  #provisioner "breakpoint" {
  #  disable = false
  #  note    = "this is a breakpoint to be able to inspect the VM contents"
  #}

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

  # Packer doesn't have permissions to make changes to root owned paths - do it via shell sudo
  #
  # Upload failed: scp: /etc/packer-version: Permission denied
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
      "env | grep PACKER || :",
      "echo Build UUID ${build.PackerRunUUID}",
      "echo Source '${source.name}' type '${source.type}'",
      "echo Creating ~/vboxsf",
      "mkdir -p -v ~/vboxsf",
      "echo Adding shared folder to VM",
      # errors out with 'line 11: no: No such file or directory'
      #"VBoxManage sharedfolder add {{.Name}} --name vboxsf --hostpath ~/vboxsf --automount --transient",
      #"VBoxManage sharedfolder add ubuntu --name vboxsf --hostpath ~/vboxsf --automount --transient",
      "VBoxManage sharedfolder add $PACKER_BUILD_NAME --name vboxsf --hostpath ~/vboxsf --automount --transient",
    ]
  }

  # https://developer.hashicorp.com/packer/docs/provisioners/shell
  #
  provisioner "shell" {
    #script = "/path/to/script.sh"
    #script = "./script.sh"
    #scripts = [
    #  "/path/to/script.sh",
    #  "./script.sh"
    #]
    environment_vars = [
      "FOO=bar"
    ]
    execute_command = "echo 'packer' | sudo -S -E bash '{{ .Path }}'"
    inline = [
      "env",
      # pre-authorize sudo - or run whole shell as root using execute_command above
      #"echo 'packer' | sudo -S echo",
      "echo Built using Packer version '${packer.version}' | sudo tee /etc/packer-version",
      #"echo '${build.SSHPrivateKey}' > /tmp/packer-session.pem",  # temporary SSH private key eg. git clone a private repo git@github.com:org/repo
      "sudo mkdir -pv /mnt/vboxsf",
      "echo Mounting /mnt/vboxsf",
      "sudo mount -t vboxsf vboxsf /mnt/vboxsf",
      # mount point is owned by root
      "sudo cp -fv /var/log/installer/autoinstall-user-data /mnt/vboxsf/",
    ]
    # max_retries = 5
    # timeout = "5m"
  }

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
    output              = "output-{{.BuildName}}/{{.BuildName}}.{{.ChecksumType}}"  # default: packer_{{.BuildName}}_{{.BuilderType}}_{{.ChecksumType}}.checksum, at top level not in the directory with the .ova, and it keeps appending to it
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

build {
  name = "debian"

  sources = ["source.virtualbox-iso.debian"]

  # unable to generate this during install - see adjacent file preseed.cfg for details
  #provisioner "file" {
  #  source      = "/var/log/preseed.cfg"
  #  destination = "preseed.cfg.new"
  #  direction   = "download"
  #}

  # https://developer.hashicorp.com/packer/docs/provisioners/shell-local
  #
  provisioner "shell-local" {
    inline = [
      "env | grep PACKER || :",
      "echo Build UUID ${build.PackerRunUUID}",
      "echo Source '${source.name}' type '${source.type}'",
      "echo Creating ~/vboxsf",
      "mkdir -p -v ~/vboxsf",
      "echo Adding shared folder to VM",
      #"VBoxManage sharedfolder add debian --name vboxsf --hostpath ~/vboxsf --automount --transient",
      "VBoxManage sharedfolder add $PACKER_BUILD_NAME --name vboxsf --hostpath ~/vboxsf --automount --transient",
    ]
  }

  # https://developer.hashicorp.com/packer/docs/provisioners/shell
  #
  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S -E bash '{{ .Path }}'"
    inline = [
      "env",
      # pre-authorize sudo - or run whole shell as root using execute_command above
      #"echo 'packer' | sudo -S echo",
      "echo Built using Packer version '${packer.version}' | sudo tee /etc/packer-version",
      #"echo '${build.SSHPrivateKey}' > /tmp/packer-session.pem",  # temporary SSH private key eg. git clone a private repo git@github.com:org/repo
      "sudo mkdir -pv /mnt/vboxsf",
      "echo Mounting /mnt/vboxsf",
      "sudo mount -t vboxsf vboxsf /mnt/vboxsf",
      # mount point is owned by root
      # preseed.cfg is not created - see adjacent file preseed.cfg for details
      #"sudo cp -fv /var/log/preseed.cfg /mnt/vboxsf/",
    ]
    # max_retries = 5
    # timeout = "5m"
  }

  # post-processor blocks run in parallel
  #
  post-processor "checksum" {               # checksum image
    checksum_types      = ["md5", "sha512"] # checksum the artifact
    keep_input_artifact = true              # keep the artifact
    output              = "output-{{.BuildName}}/{{.BuildName}}.{{.ChecksumType}}"  # default: packer_{{.BuildName}}_{{.BuilderType}}_{{.ChecksumType}}.checksum, at top level not in the directory with the .ova, and it keeps appending to it
  }
}

build {
  name = "fedora"

  sources = ["source.virtualbox-iso.fedora"]

  # Packer gets permission denied, get it via sudo in shell
  #provisioner "file" {
  #  source      = "/root/anaconda-ks.cfg"
  #  destination = "anaconda-ks.cfg.new"
  #  direction   = "download"
  #}

  # https://developer.hashicorp.com/packer/docs/provisioners/shell-local
  #
  provisioner "shell-local" {
    inline = [
      "env | grep PACKER || :",
      "echo Build UUID ${build.PackerRunUUID}",
      "echo Source '${source.name}' type '${source.type}'",
      "echo Creating ~/vboxsf",
      "mkdir -p -v ~/vboxsf",
      "echo Adding shared folder to VM",
      #"VBoxManage sharedfolder add fedora --name vboxsf --hostpath ~/vboxsf --automount --transient",
      "VBoxManage sharedfolder add $PACKER_BUILD_NAME --name vboxsf --hostpath ~/vboxsf --automount --transient",
    ]
  }

  # https://developer.hashicorp.com/packer/docs/provisioners/shell
  #
  provisioner "shell" {
    # needed to test for existing of logs in /root to copy out to vboxsf shared folder
    execute_command = "echo 'packer' | sudo -S -E bash '{{ .Path }}'"
    inline = [
      "env",
      # pre-authorize sudo - or run whole shell as root using execute_command above
      #"echo 'packer' | sudo -S echo",
      "echo Built using Packer version '${packer.version}' | sudo tee /etc/packer-version",
      #"echo '${build.SSHPrivateKey}' > /tmp/packer-session.pem",  # temporary SSH private key eg. git clone a private repo git@github.com:org/repo
      "mkdir -pv /mnt/vboxsf",
      "echo Mounting /mnt/vboxsf",
      "mount -t vboxsf vboxsf /mnt/vboxsf",
      # mount point is owned by root
      "cp -fv /root/anaconda-ks.cfg /mnt/vboxsf/",
      "for x in ks-pre.log ks-post.log; do if [ -f /root/$x ]; then cp -fv /root/$x /mnt/vboxsf/; fi; done"
    ]
    # max_retries = 5
    # timeout = "5m"
  }

  # post-processor blocks run in parallel
  #
  post-processor "checksum" {               # checksum image
    checksum_types      = ["md5", "sha512"] # checksum the artifact
    keep_input_artifact = true              # keep the artifact
    output              = "output-{{.BuildName}}/{{.BuildName}}.{{.ChecksumType}}"  # default: packer_{{.BuildName}}_{{.BuilderType}}_{{.ChecksumType}}.checksum, at top level not in the directory with the .ova, and it keeps appending to it
  }
}
