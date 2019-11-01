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

output "aws-instance-id" {
  value = aws_instance.nat.id
}