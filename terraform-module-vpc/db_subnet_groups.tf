#rds subnet groups
resource "aws_db_subnet_group" "private" {
  name       = local.db_subnet_group_private
  subnet_ids = aws_subnet.subnets_private[*].id

  tags = merge(
    local.default_tags,
    {

      Name = local.db_subnet_group_private
    },
  )
}

resource "aws_db_subnet_group" "public" {
  name       = local.db_subnet_group_public
  subnet_ids = aws_subnet.subnets_public[*].id

  tags = merge(
    local.default_tags,
    {
      Name = local.db_subnet_group_public

    },
  )
}
