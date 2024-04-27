#Create Public Route Table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name = local.public_route_table
    },
  )
  depends_on = [aws_vpc.VPC, aws_internet_gateway.igw]
}

# Creates Private Route Tables
resource "aws_route_table" "private_route" {
  count  = length(var.private_cidrs)
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name = "${local.private_route_table_base_name}-${var.azs_names[count.index]}"
    },
  )
  depends_on = [aws_vpc.VPC, aws_nat_gateway.nat_gw]
}

# Creates Isolate Route Tables
resource "aws_route_table" "isolate_route" {
  count  = length(var.isolated_cidrs)
  vpc_id = aws_vpc.VPC.id


  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name = "${local.isolate_route_table}-${var.azs_names[count.index]}"
    },
  )
  depends_on = [aws_vpc.VPC, aws_nat_gateway.nat_gw ]
}

# Associates Public Subnet with route table
resource "aws_route_table_association" "rt_public" {
  count          = length(var.public_cidrs)
  subnet_id      = element(aws_subnet.subnets_public.*.id, count.index)
  route_table_id = aws_route_table.public_route.id

  depends_on = [aws_route_table.public_route]
}

# Associates Private Subnet with route table
resource "aws_route_table_association" "rt_private" {
  count          = length(var.private_cidrs)
  subnet_id      = element(aws_subnet.subnets_private.*.id, count.index)
  route_table_id = element(aws_route_table.private_route.*.id, count.index)
  depends_on     = [aws_route_table.private_route]
}

# Associates Isolate Subnet with route table
resource "aws_route_table_association" "rt_isolate" {
  count          = length(var.isolated_cidrs)
  subnet_id      = element(aws_subnet.subnets_isolated.*.id, count.index)
  route_table_id = element(aws_route_table.isolate_route.*.id, count.index)
  depends_on     = [aws_route_table.isolate_route]
}
