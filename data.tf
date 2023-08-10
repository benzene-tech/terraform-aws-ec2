data "aws_availability_zones" "this" {
  count = var.instance.subnet.availability_zone == null ? 1 : 0

  state = "available"
}

data "aws_vpc" "this" {
  id      = var.vpc_id
  default = var.vpc_id == null ? true : null
}

data "aws_subnet" "this" {
  vpc_id            = data.aws_vpc.this.id
  state             = "available"
  availability_zone = coalesce(var.instance.subnet.availability_zone, one(random_shuffle.this.result))

  filter {
    name   = "map-public-ip-on-launch"
    values = [var.instance.subnet.type == "public" ? "true" : "false"]
  }
}
