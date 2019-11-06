#!/bin/bash

#
# Execute script from desktop
# mssh ubuntu@[i-XXXX] "bash -s" < ~/Desktop/execute_playbook.sh
#
#Enter The AWS instance id of Server1 [i-XXXX]
ID1="i-0354c27a504a93f5b"
#Enter The AWS instance DNS of Server1 [EC2.PUBLIC.DNS]
DNS1="ip-172-31-173-142.us-west-2.compute.internal"
#Enter The AWS availability zone of Server1 [us-west-2c]
AZ1="us-west-2b"
#Enter The AWS instance id of Server2 [i-XXXX]
ID2="i-0e30d812b31669aae"
#Enter The AWS instance DNS of Server2 [EC2.PUBLIC.DNS]
DNS2="ip-172-31-201-121.us-west-2.compute.internal"
#Enter The AWS availability zone of Server2 [us-west-2c]
AZ2="us-west-2c"
#AWS CLI variables
DEFAULT_ACCESS_KEY=""
DEFAULT_SECRET_KEY=""
#setup AWS CLI
aws configure set aws_access_key_id "$DEFAULT_ACCESS_KEY"
aws configure set aws_secret_access_key "$DEFAULT_SECRET_KEY"
aws configure set default.region "us-west-2"
#export ANSIBLE_HOST_KEY_CHECKING=False
#clone repo
git clone https://github.com/alexcoward/Project1Infrastructure.git
#generate rsa keypair
yes y |ssh-keygen -q -t rsa -f my_rsa_key -N '' >/dev/null
#send ssh keys and execute playbook
aws ec2-instance-connect send-ssh-public-key --region us-west-2 --instance-id "$ID1" --instance-os-user ubuntu \
--availability-zone "$AZ1" --ssh-public-key file://my_rsa_key.pub && aws ec2-instance-connect send-ssh-public-key \
--region us-west-2 --instance-id "$ID2" --instance-os-user ubuntu --availability-zone "$AZ2" --ssh-public-key file://my_rsa_key.pub \
&& ansible-playbook /home/ubuntu/Project1Infrastructure/ansible/setup_all.yml
#cleanup
rm -rf Project1Infrastructure/
rm -f my_rsa_key
rm -r my_rsa_key.pub
#exit
exit 0