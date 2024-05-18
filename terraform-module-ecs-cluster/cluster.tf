resource "aws_ecs_cluster" "product_cluster" {

  name = local.cluster_name

  tags = merge(
    local.default_tags,
    {
      Name = "${local.cluster_name}"
    },
  )
}

