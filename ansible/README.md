# Project1

This Ansible role will do the following on two remote Ubuntu 16 LTS servers located in a private subnet:

- Install and configure Apache2 and enable Apache2 modules needed for Artifactory
- Install the Open Java Development Kit 11
- Install EC2 Instance Connect
- Install and configure Artifactory Artifactory Install Info

It will also do the following on one remote Ubuntu 16 LTS bastion server located in the public domain:

- Install fail2ban
- Setup the AWS CLI with IAM username and password

## Dependencies

Ansible >= 2.0
An AWS account along with the associated credentials and an [S3 backend resource](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/SetupTerraformBackend). 
Terraform installed locally. 
[The provisioned VPC](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/VPC). 
[The provisioned EC2 infrastructure](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/EC2).

## Run

- Run from a computer that has been whitelisted to connect via mssh to the bastion.
- Clone Project1Infrastructure repo, git clone https://github.com/alexcoward/Project1Infrastructure.git
- *Copy file Project1Infrastructure/ansible/execute_playbook.sh to your desktop to avoid sharing secrets with the world
- Enter the following variables into the script. ID1 DNS1 AZ1 ID2 DNS2 AZ2 DEFAULT_ACCESS_KEY DEFAULT_SECRET_KEY
- Modify the hosts file with the private IP addresses of both servers, server1 ansible_host=PRIVATE.IP.ADDRESS
- Push or pull modified host file into master branch
- In the jail.local file update the destemail, sender, and sendername
- Push or pull modified host file into master branch
- Run the Ansible playbook with the following command, mssh ubuntu@[INSTANCE ID OF BASTION] "bash -s" < ~/Desktop/execute_playbook.sh

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also welcome. To submit a PR, first create a fork of this Github project. Then create a topic branch for the suggested change and push that branch to your own fork.

## Contributors

Alexander Coward (maintainer)

Kindra Richie
