# -*- mode: ruby -*-
# vi: set ft=ruby :

project_dev_ip = "172.28.128.34"

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "puppetlabs/centos-7.0-64-puppet"
    config.vm.network :forwarded_port, guest: 80, host: 8887
    config.vm.hostname = "dms.dev"
    config.vm.network "private_network", ip: project_dev_ip

    config.vm.provider :virtualbox do |vbox|
        vbox.gui = false
        vbox.customize ["modifyvm", :id, "--memory", "1024"]
        vbox.customize ["modifyvm", :id, "--ioapic", "on"]
        vbox.name = "dms.dev"
    end

    config.vm.provision :shell, path: "ssh_conf/setup_ssh.sh"
	
	config.vm.provision :shell, path: "provision/bootstrap.sh"
	
    config.vm.synced_folder ".", "/home/vm-conf", owner: "vagrant", group: "vagrant"
	config.vm.synced_folder "../new-doc-system", "/home/www/public", owner: "vagrant", group: "vagrant"

    config.vm.provision :shell, :inline => "sudo /bin/systemctl start nginx.service", run: "always"
    config.vm.provision :shell, :inline => "sudo iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT", run: "always"

end