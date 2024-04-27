resource "aws_eip" "nat_eip" {
  count = length(var.public_cidrs)
  domain   = "vpc"

  tags = merge(
    local.default_tags,
    {
      Name = "${local.eip_base_name}-${var.azs_names[count.index]}"
    },
  )

  depends_on = [aws_subnet.subnets_public]
}

resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.subnets_public[count.index].id

  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name = "${local.nat_gw_base_name}-${var.azs_names[count.index]}"
    },
  )
  depends_on = [aws_subnet.subnets_public, aws_eip.nat_eip]
}

