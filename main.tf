resource "aws_instance" "this" {
  ami                    = var.ami.id
  instance_type          = var.ami.type
  subnet_id              = one(random_shuffle.this.result)
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
    Name = var.name
  }
}

resource "aws_security_group" "this" {
  name   = var.name
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
      from_port        = ingress.key
      to_port          = coalesce(ingress.value.to_port, ingress.key)
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      security_groups  = ingress.value.security_groups
      self             = ingress.value.self
    }
  }
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
