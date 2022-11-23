variable "availability_zone_count" {
  description = "Specify number of Availability Zones to deploy to."
  type        = number
  default     = 2
}

variable "cidr_block" {
  description = "Specify a valid CIDR for new subnet."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 32))
    error_message = "Must use vald CIDR syntax."
  }
}

variable "subnet_name_prefix" {
  description = "Specify a name prefix for the new subnets."
  type        = string
}

variable "vpc_id" {
  description = "Specify vpc ID"
  type        = string
}
