#!/usr/bin/env bash

FILE_HOME="/home/vm-conf/ssh_conf"

ROOT_HOME="/root"
ROOT_SSH_HOME="$ROOT_HOME/.ssh"
ROOT_AUTHORIZED_KEYS="$ROOT_SSH_HOME/authorized_keys"

VAGRANT_HOME="/home/vagrant"
VAGRANT_SSH_HOME="$VAGRANT_HOME/.ssh"
VAGRANT_AUTHORIZED_KEYS="$VAGRANT_SSH_HOME/authorized_keys"

# Setup keys for root user.
#ssh-keygen -C root@localhost -f "$ROOT_SSH_HOME/id_rsa" -q -N ""
sudo mkdir "$ROOT_HOME/.ssh"
sudo touch "$ROOT_SSH_HOME/authorized_keys"
#sudo bash -c "cat "$FILE_HOME/id_rsa_rvagrant.pub" >> "$ROOT_AUTHORIZED_KEYS""
sudo bash -c "cat /home/vm-conf/ssh_conf/id_rsa_rvagrant.pub >> /root/.ssh/authorized_keys"
sudo chmod 644 "$ROOT_AUTHORIZED_KEYS"

# Setup keys for vagrant user.
#ssh-keygen -C vagrant@localhost -f "$VAGRANT_SSH_HOME/id_rsa" -q -N ""
#cat "$FILE_HOME/id_rsa_vagrant.pub" >> "$ROOT_AUTHORIZED_KEYS"
sudo bash -c "cat /home/vm-conf/ssh_conf/id_rsa_vagrant.pub >> /root/.ssh/authorized_keys"
cat "$FILE_HOME/id_rsa_vagrant.pub" >> "$VAGRANT_AUTHORIZED_KEYS"
chmod 644 "$VAGRANT_AUTHORIZED_KEYS"
chown -R vagrant:vagrant "$VAGRANT_SSH_HOME"