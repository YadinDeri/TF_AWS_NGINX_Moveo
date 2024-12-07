# ========= create VPC =========
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    var.tags,
    { Name = var.name }
  )
}

# ========= create the route tables =========
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.tags,
    { Name = "public-route-table" }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    { Name = "private-route-table" }
  )
}

# ========= create network connections =========

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id

  # Find the first subnet with map_public_ip_on_launch = true
  subnet_id = element(
    [for s in aws_subnet.this : s.id if s.map_public_ip_on_launch], 0
  )

  tags = {
    Name = "nat-gateway"
  }
}


resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat-eip"
  }
}
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# ========= create internet gateway =========

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "main-igw" })
}


# ========= create the subnets =========
resource "aws_subnet" "this" {
  count = length(var.subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnets[count.index].cidr_block
  availability_zone       = var.subnets[count.index].availability_zone
  map_public_ip_on_launch = var.subnets[count.index].map_public_ip_on_launch
  tags = merge(
    var.tags,
    { Name = var.subnets[count.index].name }
  )
}



# ========= create assosiation for route tables =========
locals {
  # Filter public subnets
  public_subnets = [
    for idx, subnet in var.subnets : aws_subnet.this[idx].id
    if subnet.map_public_ip_on_launch == true
  ]

  # Filter private subnets
  private_subnets = [
    for idx, subnet in var.subnets : aws_subnet.this[idx].id
    if subnet.map_public_ip_on_launch == false
  ]
}


resource "aws_route_table_association" "public" {
  count = length(local.public_subnets)

  subnet_id      = local.public_subnets[count.index]
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table.public]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private" {
  count = length(local.private_subnets)

  subnet_id      = local.private_subnets[count.index]
  route_table_id = aws_route_table.private.id

  depends_on = [aws_route_table.private]

  lifecycle {
    create_before_destroy = true
  }
}

