#
#  Author: Hari Sekhon
#  Date: [% DATE # 2013-03-14 12:32:15 +0000 (Thu, 14 Mar 2013) %]
#
#  vim:ts=4:sts=4:sw=4:et:filetype=ruby
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

# https://www.vagrantup.com/docs/vagrantfile

Vagrant.configure("2") do |config|

    # https://www.vagrantup.com/docs/boxes
    #
    # to get Hashicorp"s Ubuntu 18.04 base box:
    #
    # vagrant init hashicorp/bionic64
    #
    # or try one of the Bento boxes:
    #
    # https://app.vagrantup.com/bento
    #
    #config.vm.box = "hashicorp/bionic64"
    config.vm.box = "bento/ubuntu-18.04"

    # root login doesn't work on hashicorp/bionic64 or bento/ubuntu-18.04 box with pw 'vagrant'
    #config.ssh.username     = "root"
    #config.ssh.password     = "vagrant"
    config.ssh.insert_key = true
    #config.ssh.private_key_path = "~/.ssh/id_rsa"
                               # host_path         guest_path
    config.vm.synced_folder    "~/github",         "/github"
    config.vm.synced_folder    "../../",           "/bash-tools"
    config.ssh.forward_agent = false
    config.ssh.forward_x11   = false

    config.vm.usable_port_range = 2250..2299
    #config.vm.boot_mode = "gui"

    config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        #vb.name = "default-vagrant-hostname"    # overridden per VM
        vb.customize [
            "modifyvm", :id,
            "--name", "#{vb.name}",
            "--natdnsproxy1", "on",
            "--usb", "off",
            "--audio", "none"
        ]
            # using the host's DNS is simple but less portable as it requires an extra step of adding the nodes to the host's /etc/hosts file, which is an easy step to miss, so just inject the hosts files in each VM instead
            #"--natdnshostresolver1", "on",

        # evaluates too early and gets 'default-vagrant-hostname'
        #config.vm.hostname = "#{vb.name}"
    end

    # generic provision for each VM
    #config.vm.provision :shell, :path => "../provision.sh"

    # ==================================
    config.vm.define "HOST1" do |config|  # XXX: edit
        config.vm.network "private_network", ip: "172.16.0.XX"  # XXX: edit
        config.vm.provider "virtualbox" do |vb|
            # can't set vb.name at shared level, as it evaluates too early and gets 'default-vagrant-hostname'
            vb.name = "kube1"  # XXX: edit
            vb.cpus = 3
            vb.memory = 7168
            vb.customize [
                "modifyvm", :id, "--name", "#{vb.name}"
                #"--cpus",     3,
                #"--memory", 7168
            ]
            # sets the guest OS hostname and /etc/hosts (edited by provision.sh as we want external IP and not 127.0.1.1)
            config.vm.hostname = "#{vb.name}"
        end
        # XXX: edit
        #config.vm.provision :shell, :path => "provision-HOST1.sh"
    end

    # ==================================
end
