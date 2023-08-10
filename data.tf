data "aws_vpc" "this" {
  id      = var.vpc_id
  default = var.vpc_id != null ? true : null
}

data "aws_subnet" "this" {
  vpc-id            = data.aws_vpc.this.id
  state             = "available"
  availability-zone = var.instance.subnet.availability_zone

  filter {
    name   = "map-public-ip-on-launch"
    values = [var.instance.subnet.type == "public" ? "true" : "false"]
  }
}
