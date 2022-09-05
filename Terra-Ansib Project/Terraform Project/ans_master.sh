#!/bin/bash
echo "Installing Epel Release"
sudo yum install epel-release -y
echo "Installing Ansible"
sudo yum install ansible -y
sudo -i
# Creating SSH Key.
yes "/home/centos/.ssh/id_rsa" | ssh-keygen -t rsa -N ""
# Sending Key 1st Server.
sshpass -p projectpass ssh-copy-id centos@10.0.1.20 -f
# Sending Key 2nd Server.
sshpass -p projectpass ssh-copy-id centos@10.0.1.30 -f
# Sending Key 3rd Server.
sshpass -p projectpass ssh-copy-id centos@10.0.1.40 -f