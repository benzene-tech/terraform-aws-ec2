variable "name_prefix" {
  description = "Prefix to name resources and tags"
  type        = string
  nullable    = false
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  nullable    = false
}

variable "instance" {
  description = "Instance config"
  type = object({
    ami  = string
    type = string
    subnet = object({
      type              = optional(string, "public")
      availability_zone = string
    })
    ingress_rules = optional(map(object({
      protocol    = string
      cidr_blocks = optional(list(string), ["0.0.0.0/0"])
    })), null)
    user_data = optional(object({
      path      = string
      arguments = optional(map(string), {})
    }), null)
    profile_role = optional(string, null)
  })
  nullable = false

  validation {
    condition     = contains(["public", "private"], var.instance.subnet.type)
    error_message = "Subnet type should be either 'public' or 'private'"
  }

  validation {
    condition     = alltrue([for port in var.instance.port : true if signum(port.number) == 1 && port.number % 1 == 0])
    error_message = "Port numbers should be a whole number"
  }
}
