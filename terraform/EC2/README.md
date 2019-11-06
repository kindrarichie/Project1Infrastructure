# Project1 EC2

These Terraform files will provision EC2 infrastructure in an AWS account.  

This establishes the following:

- One bastion of jump instance in Public subnet 1 associated with the bastion instance security group. It allows inbound ssh traffic from Team Aerial's members and from CSUN. It allows ssh, dns, http, and https traffic out
- Two EC2 web server type t2.micro instances. Web server 1 is located in Private subnet 2. Web server 2 is located in Private subnet 3. They are associated with the server security group. It allows inbound http, https, ssh, and icmp traffic. All traffic is allowed for egress
- One application load balancer (ALB) with session stickiness. It is associated with the server security group. The ALB functions in the Public Subnets of availability zones a and b. The targets are web servers 1 and 2
- Two Elastic IP addresses. One associated with the NAT instance and one associated with the bastion of jump instance
- AWS Route 53 service
- AWS Certificate Manager (ACM) service

## Dependencies

An AWS account along with the associated credentials and an [S3 backend resource](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/SetupTerraformBackend). 
Terraform installed locally. 
[The provisioned VPC](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/VPC). 

## Installation

Replace the variable defaults with your preferred setup. Run terraform plan and then apply. Optionally, first create a new directory for all three files depending on the file layout your prefer. If creating a new directory, be sure to change the key for the backend resource. 

## Inputs

| Name | Description | Type |
|------|-------------|:----:|
| region | Region of launch | string |
| AMIID | Amazon machine image | string |
| ssl_certificate_id | ACM ssl certificate id | string |
| domain | website domain | string |
| cidr_blocks_whitelist1 | IP addresses to whitelist | string |
| cidr_blocks_whitelist2 | IP addresses to whitelist | string |
| aws_key_name | key pair | string |

## Outputs

| Name | Description |
|------|-------------|
| bastion-instance-id | bastion id |
| webserver1-instance-id | webserver1 id |
| webserver2-instance-id | webserver2 id |
| webserver-sg-id | server sg id |
| bastion-sg-id | bastion sg id |

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also welcome. To submit a PR, first create a fork of this Github project. Then create a topic branch for the suggested change and push that branch to your own fork.

## Contributors

Alexander Coward (maintainer)

Kindra Richie
