variable "availability_zone_count" {
  description = "Specify number of Availability Zones to deploy to."
  type        = number
  default     = 2

  validation {
    condition     = can(regex("^[1-9][0-9]?$|^10$", var.availability_zone_count))
    error_message = "Must be number between 1-10."
  }
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

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.subnet_name_prefix))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters."
  }
}

variable "vpc_id" {
  description = "Specify vpc ID"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.vpc_id))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters."
  }
}
