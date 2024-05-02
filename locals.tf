locals {
  validity = can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$", var.spot.validity)) ? {
    base = var.spot.validity
  } : zipmap(regexall("[smhdy]", var.spot.validity), regexall("\\d+(?:\\.\\d+)?", var.spot.validity))
}
