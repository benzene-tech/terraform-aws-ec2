resource "aws_vpc_endpoint" "this" {
  for_each = !var.nat_gateway_enabled ? toset(["ec2messages", "ssmmessages", "ssm"]) : []

  service_name        = "com.amazonaws.${data.aws_region.this.name}.${each.value}"
  vpc_id              = data.aws_vpc.this.id
  subnet_ids          = data.aws_subnets.this["private"].ids
  security_group_ids  = aws_security_group.vpc_endpoint[*].id
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "vpc_endpoint" {
  count = !var.nat_gateway_enabled ? 1 : 0

  name   = var.name
  vpc_id = data.aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }
}
