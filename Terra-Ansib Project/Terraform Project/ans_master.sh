#!/bin/bash
echo "Installing Epel Release"
yum install epel-release -y
echo "Installing Ansible"
yum install ansible -y
echo "Installing Git"
yum install git -y
sudo ssh-keygen -q -t ed25519 -N '' -f ~/.ssh/ansible
sudo ssh-keyscan -H 10.0.2.10 10.0.2.20 10.0.2.30 >> ~/.ssh/known_hosts
sudo sshpass -p projectpass ssh-copy-id -i /home/centos/.ssh/ansible.pub centos@10.0.2.10
sudo sshpass -p projectpass ssh-copy-id -i /home/centos/.ssh/ansible.pub centos@10.0.2.20
sudo sshpass -p projectpass ssh-copy-id -i /home/centos/.ssh/ansible.pub centos@10.0.2.30
sudo git clone https://github.com/Cevap05/Projects.git /home/centos/Projects/
#cd /home/centos/Projects/Ansible\ Project/ && ansible-playbook -i inventory playbook_hostkeyaccept_initial.yaml
sudo cd /home/centos/Projects/Ansible\ Project/ && ansible all -m ping > ~/ans_stuff.txt


