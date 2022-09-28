variable "name" {
  type     = string
  nullable = false
}

# VPC
variable "vpc_cidr_block" {
  type     = string
  nullable = false
}

variable "public_subnets_count" {
  default  = 2
  type     = number
  nullable = false

  validation {
    condition     = var.public_subnets_count % 1 == 0
    error_message = "Number of public subnets should be a whole number"
  }

  validation {
    condition     = var.public_subnets_count > 1
    error_message = "Minimum of two public subnets are required"
  }
}

# Instance
variable "instance_ami" {
  type     = string
  nullable = false
}

variable "instance_type" {
  type     = string
  nullable = false
}

variable "user_data_path" {
  default = null
  type    = string
}

variable "user_data_arguments" {
  default = {}
  type    = map(any)
}

variable "port" {
  type     = number
  nullable = false

  validation {
    condition     = var.port % 1 == 0
    error_message = "Port number should be a whole number"
  }
}

# Load balancer
variable "ingress_cidr_blocks" {
  default  = ["0.0.0.0/0"]
  type     = list(string)
  nullable = false
}
