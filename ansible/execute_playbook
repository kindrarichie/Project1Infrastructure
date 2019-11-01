#!/bin/bash

echo "This script will execute an ansible playbook"
echo "to deploy a website to two Ubuntu servers"
echo "located in us-west-2 with user ubuntu"
# Server1
read -p "Enter The AWS instance id of Server1 [i-XXXX] " ID1
read -p "Enter The AWS instance DNS of Server1 [EC2.PUBLIC.DNS] " DNS1
read -p "Enter The AWS availability zone of Server1 [us-west-2c] " AZ1
# Server2
read -p "Enter The AWS instance id of Server2 [i-XXXX] " ID2
read -p "Enter The AWS instance DNS of Server2 [EC2.PUBLIC.DNS] " DNS2
read -p "Enter The AWS availability zone of Server2 [us-west-2c] " AZ2
# generate rsa keypair
ssh-keygen -t rsa -f my_rsa_key
# create hosts file
echo "[webservers]" > /home/ubuntu/hosts
echo "server1 ansible_host=$DNS1 ansible_port=22 ansible_ssh_private_key_file=./my_rsa_key" >> /home/ubuntu/hosts
echo "server2 ansible_host=$DNS2 ansible_port=22 ansible_ssh_private_key_file=./my_rsa_key" >> /home/ubuntu/hosts
# send ssh keys and execute playbook
aws ec2-instance-connect send-ssh-public-key --region us-west-2 --instance-id "$ID1" --instance-os-user ubuntu --availability-zone "$AZ1" --ssh-public-key file://my_rsa_key.pub && aws ec2-instance-connect send-ssh-public-key --region us-west-2 --instance-id "$ID2" --instance-os-user ubuntu --availability-zone "$AZ2" --ssh-public-key file://my_rsa_key.pub && ansible-playbook -i /home/ubuntu/hosts /home/ubuntu/Project1Infrastructure/ansible/project1.yml 