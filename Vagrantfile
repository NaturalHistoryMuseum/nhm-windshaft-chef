# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "nhm-windshaft-berkshelf"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"

  # more memory, so that mapnik will compile

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1600]
  end

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe("nhm-windshaft")

    # The firewall is controlled by attributes on the node. Change the IP
    # address range to suit.
    chef.json = {
      firewall: {
        rules: [
          { windshaft: {
            port: "4000",
            source: "192.168.0.0/16",
            action: "allow"
            }
          }
        ]
      }
    }
  end

  # Some further settings that could prove useful when developing

  # config.vm.network "forwarded_port", guest: 4000, host: 4444
  # config.vm.synced_folder "/tmp/nhm/data", "/var/nhm-data"
  # config.vm.network :private_network, ip: "10.11.12.44"
end
