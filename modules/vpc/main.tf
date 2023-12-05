locals {
  dd_tags = {
    Datadog     = "true"
    SideScanner = "true"
  }
  public_cidr  = cidrsubnet(var.cidr, 3, 0)
  private_cidr = cidrsubnet(var.cidr, 3, 4)
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr

  tags = merge({ "Name" = var.name }, var.tags, local.dd_tags)
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({ "Name" = var.name }, var.tags, local.dd_tags)
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.public_cidr

  tags = merge({ "Name" = "${var.name}-public" }, var.tags, local.dd_tags)
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge({ "Name" = var.name }, var.tags, local.dd_tags)
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.internet_gateway]

  tags = merge({ "Name" = "${var.name}" }, var.tags, local.dd_tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({ "Name" = "${var.name}-public" }, var.tags, local.dd_tags)
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.private_cidr

  tags = merge({ "Name" = "${var.name}-private" }, var.tags, local.dd_tags)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({ "Name" = "${var.name}-private" }, var.tags, local.dd_tags)
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}