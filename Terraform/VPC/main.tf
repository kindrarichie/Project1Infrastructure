#VPC Bucket Creation

terraform {
   backend "s3" {
   region = "us-west-2"
   bucket = "project1-terraform-backend-bucket"
   key    = "VPC/terraform.tfstate"
   dynamodb_table = "project1-terraform-backend-table"
  }
}

provider "aws" {
  version = "~> 2.33"
  region = "us-west-2"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "default"
}

## VPC Creation

resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.vpc_tenancy}"
  tags = {
    tag-key = "project-project1"
    Name = "vpc"
  }
}

## Internet gateway creation

resource "aws_internet_gateway" "IGW" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    tag-key = "project-project1"
    Name = "ig"
  }
}

## Public subnet 1 creation

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.p_subnet_cidr}"
  availability_zone       = "${var.p_subnet_az}"
  map_public_ip_on_launch = "${var.p_subnet_map_public_ip}"
  tags = {
    tag-key = "project-project1"
    Name = "public_subnet1"
  }
}

## Public Subnet 2 creation

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.p_subnet_cidr2}"
  availability_zone       = "${var.p_subnet_az2}"
  map_public_ip_on_launch = "${var.p_subnet_map_public_ip}"
  tags = {
    tag-key = "project-project1"
    Name = "public_subnet2"
  }
}

## Public Subnet 3 creation

resource "aws_subnet" "public_subnet3" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.p_subnet_cidr3}"
  availability_zone       = "${var.p_subnet_az3}"
  map_public_ip_on_launch = "${var.p_subnet_map_public_ip}"
  tags = {
    tag-key = "project-project1"
    Name = "public_subnet3"
  }
}

## Private subnet 1 creation

resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.pr_subnet_cidr}"
  availability_zone       = "${var.pr_subnet_az}"
  map_public_ip_on_launch = "${var.pr_subnet_map_public_ip}"
  tags = {
    tag-key = "project-project1"
    Name = "private_subnet1"
  }
}

## Private subnet 2 creation

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.pr_subnet_cidr2}"
  availability_zone       = "${var.pr_subnet_az2}"
  map_public_ip_on_launch = "${var.pr_subnet_map_public_ip}"
  tags = {
    tag-key = "project-project1"
    Name = "private_subnet2"
  }
}

## Private subnet 3 creation

resource "aws_subnet" "private_subnet3" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.pr_subnet_cidr3}"
  availability_zone       = "${var.pr_subnet_az3}"
  map_public_ip_on_launch = "${var.pr_subnet_map_public_ip}"
  tags = {
    tag-key = "project-project1"
    Name = "private_subnet3"
  }
}

## Routetable creation for public subnet
resource "aws_route_table" "PublicSubnetRouteTable" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IGW.id}"
  }
  tags = {
    tag-key = "project-project1"
    Name = "route-public"
  }
}

## Route table association for public subnet 1
resource "aws_route_table_association" "mapping_subnet_to_rt" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.PublicSubnetRouteTable.id}"
}

## Route table association for public subnet 2
resource "aws_route_table_association" "mapping_subnet_to_rt2" {
  subnet_id      = "${aws_subnet.public_subnet2.id}"
  route_table_id = "${aws_route_table.PublicSubnetRouteTable.id}"
}

## Route table association for public subnet 2
resource "aws_route_table_association" "mapping_subnet_to_rt3" {
  subnet_id      = "${aws_subnet.public_subnet3.id}"
  route_table_id = "${aws_route_table.PublicSubnetRouteTable.id}"
}

/*
  NAT Instance SG
*/
resource "aws_security_group" "nat" {
  name        = "vpc_nat"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "NAT_SG"
  }

}
/*
  NAT Instance
*/
resource "aws_instance" "nat" {
  ami                         = "ami-0541ea7d" # this is a special ami preconfigured to do NAT
  availability_zone           = "us-west-2a"
  instance_type               = "t2.micro"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.nat.id}"]
  subnet_id                   = "${aws_subnet.public_subnet.id}"
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "NAT"
  }
}
/*
  NAT Instance EIP
*/
resource "aws_eip" "nat" {
  instance = "${aws_instance.nat.id}"
  vpc      = true
}

## Route table creation for private subnet 1

resource "aws_route_table" "PrivateSubnetARouteTable" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
  tags = {
    tag-key = "project-project1"
    Name = "route-public"
  }
}

## Route table association for private subnet 1

resource "aws_route_table_association" "mapping_subnet_to_pr_rt" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.PrivateSubnetARouteTable.id}"
}

## Route table association for privatesubnet 2

resource "aws_route_table_association" "mapping_subnet_to_pr_rtB" {
  subnet_id      = "${aws_subnet.private_subnet2.id}"
  route_table_id = "${aws_route_table.PrivateSubnetARouteTable.id}"
}

## Route table association for privatesubnet 3

resource "aws_route_table_association" "mapping_subnet_to_pr_rtC" {
  subnet_id      = "${aws_subnet.private_subnet3.id}"
  route_table_id = "${aws_route_table.PrivateSubnetARouteTable.id}"

}


## Output of vpc , subnets and CIDRs


output "subnet-pvt1" {
  value = aws_subnet.private_subnet.id
}
output "subnet-pvt2" {
  value = aws_subnet.private_subnet2.id
}
output "subnet-pvt3" {
  value = aws_subnet.private_subnet3.id
}

output "subnet-pub1" {
  value = aws_subnet.public_subnet.id
}
output "subnet-pub2" {
  value = aws_subnet.public_subnet2.id
}
output "subnet-pub3" {
  value = aws_subnet.public_subnet3.id
}
output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "vpc-cidr" {
  value = "${var.vpc_cidr}"
}
output "public-subnet-1-cidr" {
  value = "${var.p_subnet_cidr}"
}
output "public-subnet-2-cidr" {
  value = "${var.p_subnet_cidr2}"
}
output "public-subnet-3-cidr" {
  value = "${var.p_subnet_cidr3}"
}
output "private-subnet-1-cidr" {
  value = "${var.pr_subnet_cidr}"
}
output "private-subnet-2-cidr" {
  value = "${var.pr_subnet_cidr2}"
}
output "private-subnet-3-cidr" {
  value = "${var.pr_subnet_cidr3}"
}
