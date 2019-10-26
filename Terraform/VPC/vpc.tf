
resource "aws_vpc" "vpc" {
  cidr_block           = "${local.vpc_cidr_prefix}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.resource_tags, map("Name", "vpc${local.tf_naming_conv}"))
}

data "aws_availability_zones" "azs_available" {
  state = "available"
}
