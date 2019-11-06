# Project1 VPC

These Terraform files will deploy a VPC in an AWS account.  

This establishes the following:

- One virtual private cloud (VPC) located in Region US West Oregon. VPC CIDR 172.31.0.0/16
- Three availability zones. us-west-2a, us-west-2b, us-west-2c
- Three public subnets and three private subnets. Public subnet (1) 172.31.0.0/19, Public subnet (2) 172.31.32.0/19, Public subnet (3) 172.64.64.0/19, Private subnet (1) 172.31.128.0/19, Private subnet (2) 172.31.160.0/19, Private subnet (3) 172.31.192.0/19
- One network address translation (NAT) instance in Public subnet 1 associated with a security group. It allows inbound/outbound http, https, ssh, and icmp traffic.
- Two routing tables. Public route table and Private route table 
- One internet gateway

## Dependencies

An AWS account along with the associated credentials and an [S3 backend resource](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/SetupTerraformBackend). 
Terraform installed locally. 

## Installation

Replace the variable defaults with your preferred setup. Run terraform plan and then apply. Optionally, first create a new directory for all three files depending on the file layout your prefer. If creating a new directory, be sure to change the key for the backend resource. 

## Inputs

| Name | Description | Type |
|------|-------------|:----:|
| region | Region of launch | string |
| vpc_cidr | CIDR Block VPC | string |
| vpc_tenancy | VPC Tenancy | string |
| vpc_tags | VPC Tag Name | string |
| internet_gateway_tags | Tag name Internet Gateway | string |
| p_subnet_cidr | CIDR public subnet 1 | string |
| p_subnet_az | AZ public subnet 1 | string |
| p_subnet_map_public_ip | public IP address instances launched in subnet | string |
| p_subnet_tags | tag name public subnet 1 | string |
| p_subnet_cidr2 | CIDR public subnet 2 | string |
| p_subnet_az2 | AZ public subnet 2 | string |
| p_subnet_cidr3 | CIDR public subnet 3 | string |
| p_subnet_az3 | AZ public subnet 3 | string |
| pr_subnet_cidr | CIDR private subnet 1 | string |
| pr_subnet_az | AZ  private Subnet 1 | string |
| pr_subnet_map_public_ip | private IP address instances launched in  subnet | string |
| pr_subnet_cidr2 | CIDR private subnet 2 | string |
| pr_subnet_az2 | AZ  private Subnet 2 | string |
| pr_subnet_cidr3 | CIDR private subnet 3 | string |
| pr_subnet_az3 | AZ  private Subnet 3 | string |
| public_route_table_tags | tag name public route table | string |
| private_route_table_tags | tag name for private route table | string |
| aws_key_name | key Pair | string |

## Outputs

| Name | Description |
|------|-------------|
| subnet-pvt1 | subnet id |
| subnet-pvt2 | subnet id |
| subnet-pvt3 | subnet id |
| subnet-pub1 | subnet id |
| subnet-pub2 | subnet id |
| subnet-pub3 | subnet id |
| vpc-id | vpc id |
| vpc-cidr | vpc cidr block |
| public-subnet-1-cidr | subnet cidr block |
| public-subnet-2-cidr | subnet cidr block |
| public-subnet-3-cidr | subnet cidr block |
| private-subnet-1-cidr | subnet cidr block |
| private-subnet-2-cidr | subnet cidr block |
| private-subnet-3-cidr | subnet cidr block |
| aws-instance-id | nat instance id |

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also welcome. To submit a PR, first create a fork of this Github project. Then create a topic branch for the suggested change and push that branch to your own fork.

## Contributors

Alexander Coward (maintainer)

Kindra Richie
