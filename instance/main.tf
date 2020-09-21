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

variable "instance_name" {}
variable "instance_zone" {}
variable "instance_type" {
  default = "n1-standard-1" # make optional
}
variable "instance_subnetwork" {}

resource "google_compute_instance" "vm_instance" {
  name         = "${var.instance_name}"
  zone         = "${var.instance_zone}"
  machine_type = "${var.instance_type}"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    subnetwork = "${var.instance_subnetwork}"
    access_config {
      # allocates a one-to-one NAT IP to the instance
    }
  }
}
