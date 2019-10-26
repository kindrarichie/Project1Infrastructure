
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.resource_tags, map("Name", "igw${local.tf_naming_conv}"))
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip_natgw[count.index].id
  subnet_id     = aws_subnet.subnet_public[count.index].id

  tags = merge(local.resource_tags, map("Name", "natgw${count.index}${local.tf_naming_conv}"))

  count = local.nat_gateways_to_create
}

resource "aws_eip" "eip_natgw" {
  vpc = true

  tags = merge(local.resource_tags, map("Name", "eip-natgw${count.index}${local.tf_naming_conv}"))

  count = local.nat_gateways_to_create
}
