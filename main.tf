resource "aws_instance" "this" {
  ami                    = var.instance.ami
  instance_type          = var.instance.type
  subnet_id              = data.aws_subnet.this.id
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data              = var.instance.user_data.path != null ? templatefile(var.instance.user_data.path, var.instance.user_data.arguments) : null
  iam_instance_profile   = var.instance.profile_role != null ? one(aws_iam_instance_profile.this[*].name) : null

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
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.instance.ingress_rules

    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

resource "aws_iam_instance_profile" "this" {
  count = var.instance.profile_role != null ? 1 : 0

  name = var.name_prefix
  role = var.instance.profile_role
}
