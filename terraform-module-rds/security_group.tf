
resource "aws_security_group" "sg" {
  name        = "${local.security_group_name}"
  description = "Security Group created for ${local.security_group_name}"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description     = "RDS Port"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = var.security_group_cidr
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.default_tags,
    {
      Name = local.security_group_name

    },
  )

  lifecycle {
    create_before_destroy = true
  }
}