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

variable "ami" {
  description = "Instance AMI"
  type        = string
  nullable    = false
}

variable "type" {
  description = "Instance type"
  type        = string
  nullable    = false
}

variable "subnet" {
  description = "Subnet type where the instance should be launched"
  type = object({
    type              = optional(string, "public")
    availability_zone = optional(string, null)
  })
  default  = {}
  nullable = false


  validation {
    condition     = contains(["public", "private"], var.subnet.type)
    error_message = "Subnet type should be either 'public' or 'private'"
  }
}

variable "ingress_rules" {
  description = "Ingress rules for the instance"
  type = map(object({
    protocol    = string
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
  }))
  default = null

  validation {
    condition     = var.ingress_rules != null ? alltrue([for port in keys(var.ingress_rules) : true if signum(port) == 1 && port % 1 == 0]) : true
    error_message = "Port numbers should be a whole number"
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
