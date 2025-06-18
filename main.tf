resource "aws_instance" "this" {
  ami                    = var.ami.id
  instance_type          = var.ami.type
  subnet_id              = one(random_shuffle.this.result)
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data              = var.user_data.path != null ? templatefile(var.user_data.path, var.user_data.arguments) : null
  iam_instance_profile   = var.profile_role != null ? one(aws_iam_instance_profile.this[*].name) : null
  hibernation            = try(var.spot.interruption_behavior == "hibernate", null)

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  dynamic "network_interface" {
    for_each = var.network_interface != null ? [var.network_interface] : []

    content {
      device_index          = 0
      network_interface_id  = network_interface.value
      delete_on_termination = false
    }
  }

  dynamic "instance_market_options" {
    for_each = var.spot != null ? [var.spot] : []

    content {
      market_type = "spot"

      spot_options {
        spot_instance_type             = instance_market_options.value.type
        instance_interruption_behavior = instance_market_options.value.interruption_behavior
        max_price                      = instance_market_options.value.max_price
        valid_until                    = try(one(time_offset.this[*].rfc3339), null)
      }
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "this" {
  name   = var.name
  vpc_id = data.aws_vpc.this.id
}

resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_iam_instance_profile" "this" {
  count = var.profile_role != null ? 1 : 0

  name = var.name
  role = var.profile_role
}

resource "random_shuffle" "this" {
  input        = one(data.aws_subnets.this[*].ids)
  result_count = 1
}

resource "time_offset" "this" {
  count = length(local.validity) > 0 ? 1 : 0

  base_rfc3339   = lookup(local.validity, "base", null)
  offset_seconds = lookup(local.validity, "s", 0)
  offset_minutes = lookup(local.validity, "m", null)
  offset_hours   = lookup(local.validity, "h", null)
  offset_days    = lookup(local.validity, "d", null)
  offset_years   = lookup(local.validity, "y", null)

  triggers = {
    validity = var.spot.validity
  }
}
