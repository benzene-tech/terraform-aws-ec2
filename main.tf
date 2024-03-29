resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.type
  subnet_id              = data.aws_subnet.this.id
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data              = var.user_data.path != null ? templatefile(var.user_data.path, var.user_data.arguments) : null
  iam_instance_profile   = var.profile_role != null ? one(aws_iam_instance_profile.this[*].name) : null

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = var.name_prefix
  }
}

resource "aws_security_group" "this" {
  name   = var.name_prefix
  vpc_id = data.aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

resource "aws_iam_instance_profile" "this" {
  count = var.profile_role != null ? 1 : 0

  name = var.name_prefix
  role = var.profile_role
}

resource "random_shuffle" "this" {
  input        = one(data.aws_availability_zones.this[*].names)
  result_count = 1
}
