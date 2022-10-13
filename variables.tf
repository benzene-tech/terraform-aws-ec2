variable "name_prefix" {
  description = "Prefix for resource and tag names"
  type        = string
  nullable    = false
}

variable "ingress_cidr_blocks" {
  description = "Ingress CIDRs for EC2"
  default     = ["0.0.0.0/0"]
  type        = list(string)
  nullable    = false
}

# VPC
variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
  nullable    = false
}

variable "public_subnets_count" {
  description = "Number of public subnets to create. If load balancer is enabled, public_subnet_count value should be minimum of 2"
  default     = 2
  type        = number
  nullable    = false

  validation {
    condition     = var.public_subnets_count % 1 == 0 && var.public_subnets_count > 0
    error_message = "Number of public subnets should be a non zero whole number"
  }
}

variable "private_subnets_count" {
  description = "Number of private subnets to create"
  default     = 0
  type        = number
  nullable    = false

  validation {
    condition     = var.private_subnets_count % 1 == 0 && var.private_subnets_count >= 0
    error_message = "Number of private subnets should be a whole number"
  }
}

variable "enable_nat_gateway" {
  description = "Switch to enable or disable NAT gateway"
  default     = false
  type        = bool
  nullable    = false
}

# Instance
variable "instance_ami" {
  description = "AMI of the instance"
  type        = string
  nullable    = false
}

variable "instance_type" {
  description = "Type of the instance"
  type        = string
  nullable    = false
}

variable "user_data_path" {
  description = "Path to the user data file"
  default     = null
  type        = string
}

variable "user_data_arguments" {
  description = "User data arguments. Required only if user_data_path is defined"
  default     = {}
  type        = map(any)
  nullable    = false
}

variable "port" {
  description = "Port in which application is running"
  type        = number
  nullable    = false

  validation {
    condition     = var.port % 1 == 0
    error_message = "Port number should be a whole number"
  }
}

# Load balancer
variable "enable_load_balancer" {
  description = "Switch to enable or disable load balancer"
  default     = false
  type        = bool
  nullable    = false
}
