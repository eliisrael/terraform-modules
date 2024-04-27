resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC.id

  tags = merge(
    local.default_tags,
    {
      Name = local.internet_gw
    },
  )

  depends_on = [aws_vpc.VPC]
}
