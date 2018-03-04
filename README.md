# Vagrant Environment

Vagrant is a tool for building and distributing development environments.
* Website: [https://www.vagrantup.com/](https://www.vagrantup.com/)
* Source: [https://github.com/hashicorp/vagrant](https://github.com/hashicorp/vagrant)



## SSH Modification - Before you begin

By default vagrant comes packaged with default SSH key (which is insecure). 
Here we need to create two SSH keys to use with our environment.

Generate keys using 

`ssh-keygen -t rsa -b 4096 -C "EMAIL"` 

Name them 
	`id_rsa_rvagrant` 
	`id_rsa_vagrant` 

Note: (if you name them differently you need to modify `ssh_conf/setup_ssh.sh` )


Put these files inside 

`ssh_conf/` 

## Quick Start

To build your virtual environment:

    vagrant init
    vagrant up
	
Note: The above `vagrant up` command will also trigger Vagrant to download the
`centos-7.0-64-puppet` box via the specified URL. Vagrant only does this if it detects that
the box doesn't already exist on your system.

Once machine is up you can simply connect it to via SSH with user root or vagrant

Note: Don't forget to add private keys to you SSH-agent using `ssh-add`


