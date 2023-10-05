data "aws_vpc" "this" {
  id      = var.vpc_id
  default = var.vpc_id == null ? true : null
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "availability-zone"
    values = [var.subnet.availability_zone]
  }


  filter {
    name   = "map-public-ip-on-launch"
    values = [var.subnet.type == "public" ? "true" : "false"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
