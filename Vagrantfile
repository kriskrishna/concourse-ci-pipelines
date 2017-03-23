# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "rhel7u2-bp0-dev"  
  config.vm.network "public_network" 
  config.vm.provision "shell", path: "./vagrant/bootstrap.sh"
end