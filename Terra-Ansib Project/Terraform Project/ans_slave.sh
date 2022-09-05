#!/bin/bash
sudo echo 'centos:projectpass' | sudo chpasswd
sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
echo "Restart SSHD"
sudo systemctl restart sshd