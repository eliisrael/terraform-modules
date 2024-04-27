resource "aws_vpc" "VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support


  # adding name tag  
  tags = merge(
    local.default_tags,
    {
      Name = local.vpc_name
    },
  )

  lifecycle {
    ignore_changes  = [cidr_block, enable_dns_hostnames, enable_dns_support]
    prevent_destroy = false
  }

}