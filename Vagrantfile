# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu-14.04-amd64"
  config.vm.box_url = "https://s3.amazonaws.com/covisintrnd.com-software/vagrant/ubuntu-14.04-amd64.box"
  config.vm.provision "shell", path: "vagrant/provision.sh"
  config.vm.network :forwarded_port, host: 12345, guest: 12345
end
