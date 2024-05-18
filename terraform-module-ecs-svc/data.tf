data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = "Private"
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = "Public"
  }
}

data "aws_ecs_cluster" "product_cluster" {
  cluster_name = var.cluster_name
}

data "aws_acm_certificate" "cert" {
  domain   = var.certificate_domain
  statuses = ["ISSUED"]
}