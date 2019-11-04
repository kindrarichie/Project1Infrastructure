# AWS region

variable "region" {
  type        = "string"
  description = "Region of launching EC2"
  default     = "us-west-2"
}

#AWS VPC CIDR Range

variable "vpc_cidr" {
  type        = "string"
  description = "CIDR Block for VPC"
  default     = "172.31.0.0/16"
}

# vpc Tenancy has been set to default

variable "vpc_tenancy" {
  type        = "string"
  description = "VPC Tenancy"
  default     = "default"
}

variable "vpc_tags" {
  type        = "string"
  description = "VPC Tag Name"
  default     = "vpc"
}

variable "internet_gateway_tags" {
  type        = "string"
  description = "Tag name for Internet Gateway"
  default     = "IGW"
}

#AWS Public Subnet 1

## Public subnet CIDR range

variable "p_subnet_cidr" {
  type        = "string"
  description = "CIDR for first public subnet"
  default     = "172.31.0.0/19"
}

## Public Subnet 1 Availability zone

variable "p_subnet_az" {
  type        = "string"
  description = "AZ for first Public Subnet"
  default     = "us-west-2a"
}

variable "p_subnet_map_public_ip" {
  type        = "string"
  description = "This will provide Public IP address to instances launched in this subnet"
  default     = "true"
}

variable "p_subnet_tags" {
  type        = "string"
  description = "This is the tag name for Public Subnet"
  default     = "public_subnet"
}

#AWS Public Subnet 2

## Public Subnet 2 CIDR range

variable "p_subnet_cidr2" {
  type        = "string"
  description = "CIDR for 2nd public subnet"
  default     = "172.31.32.0/19"
}

## Public Subnet 2 Availability zone

variable "p_subnet_az2" {
  type        = "string"
  description = "AZ for 2nd Public Subnet"
  default     = "us-west-2b"
}

#AWS Public Subnet 3

## Public Subnet 3 CIDR range

variable "p_subnet_cidr3" {
  type        = "string"
  description = "CIDR for 3rd public subnet"
  default     = "172.31.64.0/19"
}

## Public Subnet 3 Availability zone

variable "p_subnet_az3" {
  type        = "string"
  description = "AZ for 3rd Public Subnet"
  default     = "us-west-2c"
}

#AWS Private Subnet 1 CIDR range

variable "pr_subnet_cidr" {
  type        = "string"
  description = "CIDR for first Private subnet"
  default     = "172.31.128.0/19"
}

## AWS Private subnet 1 availability zone

variable "pr_subnet_az" {
  type        = "string"
  description = "AZ for first Private Subnet"
  default     = "us-west-2a"
}

variable "pr_subnet_map_public_ip" {
  type        = "string"
  description = "This will provide Private IP address to instances launched in this subnet"
  default     = "false"
}

variable "pr_subnet_tags" {
  type        = "string"
  description = "This is the tag name for Private Subnet"
  default     = "private_subnet"
}

#AWS Private Subnet 2  CIDR range

variable "pr_subnet_cidr2" {
  type        = "string"
  description = "CIDR for 2nd private subnet"
  default     = "172.31.160.0/19"
}

## AWS Private subnet 2 availability zone

variable "pr_subnet_az2" {
  type        = "string"
  description = "AZ for 2nd Private Subnet"
  default     = "us-west-2b"
}

#AWS Private Subnet 3  CIDR range

variable "pr_subnet_cidr3" {
  type        = "string"
  description = "CIDR for 3rd private subnet"
  default     = "172.31.192.0/19"
}

## AWS Private subnet 3 availability zone
variable "pr_subnet_az3" {
  type        = "string"
  description = "AZ for 3rd Private Subnet"
  default     = "us-west-2c"
}

# AWS Public Route Table

variable "public_route_table_tags" {
  type        = "string"
  description = "Tag name for Public Route Table"
  default     = "PublicSubnetARouteTable"
}

# AWS Private Route Table

variable "private_route_table_tags" {
  type        = "string"
  description = "Tag name for Private Route Table"
  default     = "PrivateSubnetARouteTable"
}

# Key that exists in AWS Account

variable "aws_key_name" {
  type        = "string"
  description = "Key Pair"
  default     = "testing"
}