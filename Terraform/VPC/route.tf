
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.resource_tags, map("Name", "rouretable-public${local.tf_naming_conv}"))
}

resource "aws_route" "route_public_to_igw" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "subnet_rt_association_public" {
  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.rt_public.id

  count = length(data.aws_availability_zones.azs_available.names)
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.resource_tags, map("Name", "routetable-private-${local.tf_naming_conv}"))
}

resource "aws_route" "route_private_to_natgw" {
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.*.id[length(data.aws_availability_zones.azs_available.names) % local.nat_gateways_to_create]

  count = local.nat_gateways_to_create > 0 ? length(data.aws_availability_zones.azs_available.names) : 0
}

resource "aws_route_table_association" "subnet_rt_association_private" {
  subnet_id      = aws_subnet.subnet_private[count.index].id
  route_table_id = aws_route_table.rt_private.id

  count = length(data.aws_availability_zones.azs_available.names)
}
