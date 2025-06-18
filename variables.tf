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

variable "network_interface" {
  description = "Instance ENI ID"
  type        = string
  default     = null
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

variable "spot" {
  description = "Instance spot options"
  type = object({
    type                  = string
    interruption_behavior = string
    max_price             = optional(string, null)
    validity              = optional(string, "")
  })
  default = null

  validation {
    condition     = try(contains(["one-time", "persistent"], var.spot.type), var.spot.type != null, true)
    error_message = "Type must be one either 'one-time' or 'persistent'"
  }

  validation {
    condition     = try(contains(["hibernate", "stop", "terminate"], var.spot.interruption_behavior), var.spot.interruption_behavior != null, true)
    error_message = "Interruption behavior must be one among 'hibernate', 'stop' or 'terminate'"
  }

  validation {
    condition     = can(regex("^(?:\\d+(?:\\.\\d+)?[smhdy])+$", var.spot.validity)) || can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$", var.spot.validity)) || try(var.spot.validity == "", true)
    error_message = "Validity must be either a duration or end date represented as '1h30m' or '2018-05-13T07:44:12Z' respectively"
  }
}
