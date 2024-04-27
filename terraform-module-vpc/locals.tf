locals {

  vpc_name                      = "vpc-${var.product}-${var.environment}"
  public_subnet_base_name       = "public-${var.environment}"
  private_subnet_base_name      = "private-${var.environment}"
  isolated_subnet_base_name     = "isolated-${var.environment}"
  internet_gw                   = "internet-gw-${var.environment}"
  eip_base_name                 = "eip-${var.environment}"
  nat_gw_base_name              = "nat-gw-${var.environment}"
  public_route_table            = "rt-public-${var.environment}"
  private_route_table_base_name = "rt-private-${var.environment}"
  isolate_route_table           = "rt-isolate-${var.environment}"
  db_subnet_group_public        = "db-sg-public-${var.product}-${var.environment}"
  db_subnet_group_private       = "db-sg-private-${var.product}-${var.environment}"
  default_tags = {
    Environment = var.environment
    Account     = var.account
    Module      = "terraform-module-vpc"
    Created_by  = var.created_by
    Created_at  = var.created_at
  }
}
