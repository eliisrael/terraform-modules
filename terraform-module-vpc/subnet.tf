#Create Public Subnets
resource "aws_subnet" "subnets_public" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  lifecycle {
    ignore_changes  = [cidr_block, availability_zone]
    prevent_destroy = false
  }


  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name = "${local.public_subnet_base_name}-${var.azs_names[count.index]}"
      Tier = "Public"
    },
  )
  depends_on = [aws_vpc.VPC]

}

#Create Private Subnets
resource "aws_subnet" "subnets_private" {
  count             = length(var.private_cidrs)
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = var.azs[count.index]

  lifecycle {
    ignore_changes  = [cidr_block, availability_zone]
    prevent_destroy = false
  }


  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name = "${local.private_subnet_base_name}-${var.azs_names[count.index]}"
      Tier = "Private"
    },
  )
  depends_on = [aws_vpc.VPC]
}

#Create Isolated Subnets
resource "aws_subnet" "subnets_isolated" {
  count             = length(var.isolated_cidrs)
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.isolated_cidrs[count.index]
  availability_zone = var.azs[count.index]

  lifecycle {
    ignore_changes  = [cidr_block, availability_zone]
    prevent_destroy = false
  }


  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name = "${local.isolated_subnet_base_name}-${var.azs_names[count.index]}"
      Tier = "Isolated"
    },
  )

  depends_on = [aws_vpc.VPC]
}
