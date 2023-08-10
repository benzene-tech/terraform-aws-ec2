variable "name_prefix" {
  description = "Prefix to name resources and tags"
  type        = string
  nullable    = false
}

variable "vpc_id" {
  description = "VPC ID. If VPC ID is not provided default VPC will be used"
  type        = string
  default     = null
}

variable "instance" {
  description = "Instance config"
  type = object({
    ami  = string
    type = string
    subnet = optional(object({
      type              = optional(string, "public")
      availability_zone = optional(string, null)
      }), {
      type = "public"
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
    condition     = alltrue([for port in keys(var.instance.ingress_rules) : true if signum(port) == 1 && port % 1 == 0])
    error_message = "Port numbers should be a whole number"
  }
}
