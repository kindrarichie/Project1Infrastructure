
resource "aws_subnet" "subnet_public" {
  cidr_block              = "${local.vpc_cidr_prefix}.${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.azs_available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id

  tags = merge(local.resource_tags, map("Name", "subnet${count.index}-${local.vpc_cidr_prefix}.${count.index}.0-${data.aws_availability_zones.azs_available.names[count.index]}-${local.tf_environment}"))

  count = length(data.aws_availability_zones.azs_available.names)
}

resource "aws_subnet" "subnet_private" {
  cidr_block        = "${local.vpc_cidr_prefix}.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.azs_available.names[count.index]
  vpc_id            = aws_vpc.vpc.id

  tags = merge(local.resource_tags, map("Name", "subnet${count.index}-${local.vpc_cidr_prefix}.${count.index + 10}.0-${data.aws_availability_zones.azs_available.names[count.index]}-${local.tf_environment}"))

  count = length(data.aws_availability_zones.azs_available.names)
}

