data "aws_subnet" "this" {
  vpc-id            = var.vpc_id
  state             = "available"
  availability-zone = var.instance.subnet.availability_zone

  filter {
    name   = "map-public-ip-on-launch"
    values = [var.instance.subnet.type == "public" ? "true" : "false"]
  }
}
