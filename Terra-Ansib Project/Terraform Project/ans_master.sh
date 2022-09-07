#!/bin/bash
echo "Installing Epel Release"
sudo yum install epel-release -y
echo "Installing Ansible"
sudo yum install ansible -y
echo "Installing Git"
sudo yum install git -y
sudo -i
# THIS PART UNDER NEEDS WORK STILL
# yes "/home/centos/.ssh/id_rsa" | ssh-keygen -t rsa -N ""
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
sshpass -p projectpass ssh-copy-id centos@10.0.1.20 -f
sshpass -p projectpass ssh-copy-id centos@10.0.1.30 -f
sshpass -p projectpass ssh-copy-id centos@10.0.1.40 -f