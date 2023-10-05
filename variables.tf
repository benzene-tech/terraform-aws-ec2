variable "name" {
  description = "Name resources or add as tag"
  type        = string
  nullable    = false
}

variable "vpc_id" {
  description = "VPC ID. If VPC ID is not provided default VPC will be used"
  type        = string
  default     = null
}

variable "ami" {
  description = "Instance AMI"
  type = object({
    id   = string
    type = string
  })
  nullable = false
}

variable "subnet" {
  description = "Subnet type where the instance should be launched"
  type = object({
    type              = optional(string, "public")
    availability_zone = string
  })
  nullable = false


  validation {
    condition     = contains(["public", "private"], var.subnet.type)
    error_message = "Subnet type should be either 'public' or 'private'"
  }
}

variable "ingress_rules" {
  description = "Ingress rules for the instance"
  type = map(object({
    to_port          = optional(number, null)
    protocol         = string
    cidr_blocks      = optional(list(string), null)
    ipv6_cidr_blocks = optional(list(string), null)
    security_groups  = optional(list(string), null)
    self             = optional(bool, null)
  }))
  default  = {}
  nullable = false

  validation {
    condition     = alltrue([for port in keys(var.ingress_rules) : true if signum(port) == 1 && port % 1 == 0])
    error_message = "From port numbers should be a whole number"
  }

  validation {
    condition     = alltrue([for rule in var.ingress_rules : (signum(rule.to_port) == 1 && rule.to_port % 1 == 0) if rule.to_port != null])
    error_message = "To port numbers should be a whole number"
  }

  validation {
    condition     = alltrue([for rule in var.ingress_rules : (can(coalescelist(rule.cidr_blocks, rule.ipv6_cidr_blocks, rule.security_groups)) || rule.self == true)])
    error_message = "Either one of cidr_blocks, ipv6_cidr_blocks, security_groups or self needed in order to configure the source of the traffic"
  }
}

variable "user_data" {
  description = "Instance user_data"
  type = object({
    path      = string
    arguments = optional(map(string), {})
  })
  default = null
}

variable "profile_role" {
  description = "IAM instance profile"
  type        = string
  default     = null
}
